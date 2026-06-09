<!--
  Thanks for contributing to anypoint-automation-client-generator.
  Each PR drives generated Go client modules in github.com/mulesoft-anypoint/anypoint-client-go.
  Be precise: a careless spec change ripples downstream into every Terraform / SDK consumer.
-->

## Summary

<!-- 1–3 bullets. What does this PR change? -->

-
-

## Affected modules

<!-- List every spec/<service>.yml touched. The CI pipeline regenerates these modules on master-merge. -->

- `spec/<service>.yml` →  `anypoint-client-go/<service>`

## Related

- Provider issue / PR: <link to terraform-provider-anypoint>
- Anypoint API docs (if any): <link>
- HAR evidence (if API surface was reverse-engineered): <path / commit in `recordings/`>

## Type of change

- [ ] New endpoint(s) on existing service
- [ ] New service (whole new spec file)
- [ ] Bug fix in existing schema / response
- [ ] Breaking change (renamed field, removed endpoint, changed required-ness)
- [ ] Generator config / tooling

## Spec checklist (OAS3 conventions)

- [ ] OAS 3.0.0.
- [ ] All schemas live in `#/components/schemas`; paths reference via `$ref`.
- [ ] Every schema and every attribute has a **`title`** (camelCase, unique across the spec).
- [ ] No `oneOf` / `anyOf` in response bodies — generator can't infer a Go type.
- [ ] `operationId` set on every operation, verb-prefixed, stable. Generated Go method name = this.
- [ ] Standard error responses (`401`, `403`, `404`, `400`) `$ref` shared response components instead of inlining.
- [ ] Raw-string body responses declared as `schema: { type: string }`.
- [ ] No unnecessary `required` fields.
- [ ] `npx openapi-generator-cli validate -i spec/<service>.yml` is clean.

## Local generation

- [ ] `make generate` (or `npx openapi-generator-cli generate`) succeeds with no warnings on this branch.
- [ ] Local consumer test: ran `go mod edit -replace …=./dest/<service>` in a downstream project and `go build` passes.

## Breaking change notice

<!-- If any 'Breaking change' box above is ticked, explain here. Include migration steps for downstream consumers. -->

## Release plan

- [ ] On merge to `master`, pipeline regenerates `anypoint-client-go/<service>`.
- [ ] After pipeline publishes, the affected module(s) need to be tagged. Proposed version: `<service>/vX.Y.Z` (semver bump rationale: …).
- [ ] Downstream provider/SDK consumers will switch from `replace` → released tag once the tag is up.

## Notes for reviewer

<!-- API quirks, undocumented behavior, response shape oddities (truncated/array-wrapped), etc. -->
