# Continuous Integration

This folder contains files related to continuous integration (CI) for automatically building
and rebuilding the textbook source when needed.

### Building a new version of the Docker image

```bash
docker build . -t siefkenj/build-images:ibllinearalgebra
```

### Run the docker image

```bash
docker run -v `pwd`:/workdir -w /workdir -it --rm siefkenj/build-images:ibllinearalgebra
```

### Publish the docker image

After `docker login`, run:

```bash
docker push siefkenj/build-images:ibllinearalgebra
```

### Copying book source

```bash
rsync -rl --include='*/' --include='*.tex' --include='*.sty' --include='*.png' --include='*.jpg' --include='*.svg' --include="*.cls" --include="images/*" --exclude='*' ../book/ ./book-copy/
```