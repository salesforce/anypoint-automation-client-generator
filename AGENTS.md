# AGENTS.md

Agent rules for `anypoint-automation-client-generator`. Read by Claude Code, Roo Code, Cursor, and any tool supporting the `AGENTS.md` convention.

## Project context

- This repo owns the OpenAPI 3.0.0 specs that drive every `github.com/mulesoft-anypoint/anypoint-client-go/<service>` module.
- Specs live in `spec/<service>.yml`. One file per Anypoint API (private_space, vpc, dlb, env, org, etc.).
- The CLI tool is `openapi-generator-cli` (Node, configured via `openapitools.json`).
- Downstream: `terraform-provider-anypoint` and any other Anypoint SDK consumer.

## Big picture

```
spec/<service>.yml  ──(openapi-generator-cli)──▶  dest/<service>/    (local, gitignored)
       │                                                  │
       │ PR merged to master                              │ go mod replace (during dev)
       ▼                                                  ▼
       CI generates + pushes ──▶ github.com/mulesoft-anypoint/anypoint-client-go/<service>
                                                ▲
                                                │ user tags the module
                                                │
                                  Downstream `go get @vX.Y.Z`
```

## Generator workflow

```bash
# 1. install once
npm install

# 2. point generator at a writable destination
export ANYPOINT_GENERATOR_GO_DEST=`pwd`/dest

# 3. generate everything
npx openapi-generator-cli generate

# Or just one service
make generate     # if Makefile target exists
```

Validate a single spec before generating:

```bash
npx openapi-generator-cli validate -i spec/<service>.yml
```

## Spec authoring rules

Inherited from README.md, with extra detail:

### Mandatory

- **OAS 3.0.0.** No 3.1 features.
- **All schemas in `#/components/schemas`**, referenced from paths via `$ref`. Don't inline body schemas in operations.
- **Every schema + every attribute has a `title`** in camelCase. The `title` becomes the Go struct / field name. Inconsistent titles produce ugly Go.
- **`title` must be unique across the spec.** Two different schemas titled `Spec` collide.
- **`operationId` on every operation.** It becomes the Go method name. Prefix with the verb (`Create…`, `Get…`, `Update…`, `Delete…`, `List…`). Keep stable — renaming breaks every consumer.

### Forbidden

- `oneOf` / `anyOf` in response bodies. The generator can't infer a Go type. If the field genuinely supports multiple types, leave the type empty and document with `description` only.
- `$ref` to a primitive type (string / int / bool). Use the type inline.
- Unnecessary `required` fields. Mark `required` only when the API truly rejects a missing field.

### Patterns for common shapes

- **Raw-string response body** (e.g. an account id endpoint returning `"904814986745"`):
  ```yaml
  responses:
    '200':
      content:
        application/json:
          schema:
            type: string
  ```
- **Array-wrapped single resource** (some Anypoint endpoints wrap a singleton in `[]`):
  ```yaml
  responses:
    '200':
      content:
        application/json:
          schema:
            type: array
            items:
              $ref: '#/components/schemas/TransitGateway'
  ```
- **Truncated response** vs the canonical schema: declare a separate `…Result` schema. Don't lie about which fields the API actually returns.

### Shared error responses

Reuse `#/components/responses/UnauthorizedError`, `ForbiddenError`, `BadRequestError`, `NotFoundError` instead of inlining `401`/`403`/`404` per operation. Add new shared response components there if missing.

### DELETE with body

OAS-purist editors complain; the generator supports it. Add `requestBody` anyway when the API requires it. Ignore the editor warning.

## Naming conventions

| Element | Convention | Example |
|---|---|---|
| Spec filename | `<service>.yml`, snake_case | `private_space.yml` |
| Schema title | PascalCase, unique | `TransitGateway`, `TransitGatewayPostBody` |
| Attribute title | camelCase | `resourceShareId`, `accountId` |
| operationId | `<Verb><Noun>` PascalCase | `CreatePrivateSpaceTransitGateway`, `GetOrgTransitGateways` |
| Path variable | camelCase | `{orgId}`, `{psId}`, `{tgwId}` |

## Branching & release

- Feature branches target `dev`.
- After PR review, `dev` merges to `master`.
- On `master` merge, CI generates client modules and pushes them to the `anypoint-client-go` org repository.
- **Tagging** of individual `<service>/vX.Y.Z` modules is a manual step performed by a maintainer (typically after a downstream consumer confirms the new shape compiles).
- Always specify `Proposed version: <service>/vX.Y.Z` in the PR description so the maintainer has a default to use.

## Workflow when working with a downstream consumer

Typical loop (e.g. provider asks for a new endpoint):

1. Capture API surface (HAR / docs / direct curl).
2. Edit `spec/<service>.yml`, validate.
3. Local regen (`make generate` or `npx openapi-generator-cli generate`).
4. Downstream switches via `go mod edit -replace …=./dest/<service>`. Iterate until happy.
5. Open PR here (use `.github/PULL_REQUEST_TEMPLATE.md`).
6. Merge → CI publishes generated module.
7. Maintainer tags `<service>/vX.Y.Z`.
8. Downstream switches back: `go mod edit -dropreplace …` + `go get @vX.Y.Z`.

## Avoid

- Committing anything under `dest/` (it's gitignored — keep it that way).
- Committing `node_modules/`.
- Hand-edits to generated Go in the downstream repo — fix the spec instead.
- Renaming an `operationId` or a schema `title` casually: this is a breaking change. Bump major when you do.
- Using `oneOf` / `anyOf` to "be flexible" — leaves Go callers with unusable types.

## Reference

- OpenAPI Generator: <https://openapi-generator.tech/>
- OpenAPI inheritance/polymorphism: <https://swagger.io/docs/specification/data-models/inheritance-and-polymorphism/>
- Consumer convention: `../terraform-provider-anypoint/AGENTS.md`
