# Apache Forrest Bridge

This directory introduces Apache Forrest as a local runtime dependency for
`silkpage/core+`.

The intent is not to freeze SilkPage into Forrest, but to make Forrest
available as an additional XML publishing engine that can be orchestrated:

- by SilkPage for transformation and publication
- by Singine for secure execution and policy control
- later by JDBC-style bridge drivers and virtual query surfaces

## Design

`core/` remains SilkPage's historical engine.

`core+/forrest/` is the additive integration layer for:
- local Forrest runtime validation
- delegated Forrest build execution
- bridge specifications for XML, RDF, SPARQL, GraphQL, REST, OpenAPI, xAPI,
  `systemApi().exp()`, gRPC, and remote functional execution

## Runtime contract

This integration expects a local Forrest runtime or checkout and does not
assume Maven Central coordinates.

Set one of:

```bash
export FORREST_HOME=~/ws/github/apache/forrest
export FORREST_BIN="$FORREST_HOME/bin/forrest"
```

Then run:

```bash
ant -f core+/forrest/build.xml forrest-validate
ant -f core+/forrest/build.xml forrest-version
```

## Architectural direction

The long-term bridge model is:

```text
Singine execution/authz
  -> SilkPage transformation layer
     -> Apache Forrest publishing/runtime layer
        -> virtual driver/query layer
           -> SQL / SPARQL / GraphQL / REST / OpenAPI / xAPI / systemApi / gRPC
              -> Collibra hierarchy + reference data responses
```

The canonical spec for this direction is:

- `core+/model/forrest-singine-silkpage-bridge.xml`
