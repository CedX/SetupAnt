# Basic Setup
Set up a specific version of [Apache Ant](https://ant.apache.org):

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: actions/setup-java@v5
        with:
          distribution: temurin
          java-version: 25
      - uses: cedx/SetupAnt@v6
        with:
          optional-tasks: true
          version: =1.10.17
      - run: ant -version
```
