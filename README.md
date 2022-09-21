# Cloudhub API Client Generator

## Install
Make sure to install nodejs and npm and execute the following in the root project
```bash
$ npm install
```

## Execute generator

Make sure to add `ANYPOINT_GENERATOR_GO_DEST` environment variable that should point to the destination go folder. You can use the `dist` folder of the project which is ignored in git by executing the following inside the project's folder: 
```bash
$ export ANYPOINT_GENERATOR_GO_DEST=`pwd`/dist
```

Use the following to get the manual 
```
$ npx openapi-generator-cli help 
```

Use the following command to generate using the configuration stored in `openapitools.json`
```bash
$ npx openapi-generator-cli generate
```

## How to write your spec ?

Here's some rules to keep in mind when you write your spec: 
  * Use OAS 3.0.0
  * Define your objects schemas in `#/components/schema` and reference them in your path definitions.
  * Use enheritance and polymorphism when you define your schemas to avoid redefining the same attributes multiple times. [ref](https://swagger.io/docs/specification/data-models/inheritance-and-polymorphism/).
  * For each attribute of your schemas make sure to provide a `title`. The `title` will be used to generate a structure name for that attribute, therefore use a short and consitent name. look in the existent specs for examples.
  * Use **caml case** in `title` to name your schemas attributes. 
  * When using `title` to describe an object or array, its name should be unique accross the same specification.
  * For each of your api resource, return a deterministic result and never user OneOf for example. The generator will not be able to create the appropriate Type. 
  * For all simple types (e.g integer, string ...) Don't use `$ref` to refer to the definition.
  * Make sure to remove any unnecessary `required` attributes. 
  * Though the use of body parameter is discouraged for `DELETE` operations, some APIs may require it (to delete multiple specific items for example...). In that case some editors like Swagger may show an error when you add a `requestBody` on a `DELETE` resource operation. Don't pay attention to that error since our code generator supports it. If you are annoyed by that, try using your favorite editor's plugin for openapi (example on vscode openapi [plugin](https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi)).
  * If a given field supports multiple types, don't use `oneOf` or `anyOf`. Instead, leave the type empty (add title field or description only for example). 

## Reference
* [open api generator](https://openapi-generator.tech/)
* [openapi placeholders maven](https://github.com/OpenAPITools/openapi-generator/blob/master/modules/openapi-generator-maven-plugin/README.md)
* [openapi cli placeholders](https://github.com/OpenAPITools/openapi-generator-cli/tree/master/apps/generator-cli/src#available-placeholders)
* [JSON to JSONSchema Converter Tool](https://www.jsonschema.net/home)


## Disclaimer 
**This is an [UNLICENSED software, please review the considerations](UNLICENSE.md).** 
This is an open source project, it does not form part of the official MuleSoft product stack, and is therefore not included in MuleSoft support SLAs. Issues should be directed to the community, who will try to assist on a best endeavours basis. This application is distributed **as is**.
