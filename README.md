# Cloudhub API Client Generator

## Install
Make sure to install nodejs and npm and execute the following in the root project
```bash
$ npm install
```

## Execute generator

Make sure to add `CLOUDHUB_GENERATOR_GO_DEST` environment variable that should point to the destination go folder

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
  * 

## Reference
* [open api generator](https://openapi-generator.tech/)
* [openapi placeholders maven](https://github.com/OpenAPITools/openapi-generator/blob/master/modules/openapi-generator-maven-plugin/README.md)
* [openapi cli placeholders](https://github.com/OpenAPITools/openapi-generator-cli/tree/master/apps/generator-cli/src#available-placeholders)
