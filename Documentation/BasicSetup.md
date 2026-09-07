# Basic Setup
Set up a specific version of [Apache Ant](https://ant.apache.org):

```yaml
jobs:
  Test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: actions/setup-java@v5
        with:
          distribution: temurin
          java-version: 25
      - uses: CedX/SetupAnt@v7
        with:
          optional-tasks: true
          version: =1.10.18
      - run: ant -version
```
