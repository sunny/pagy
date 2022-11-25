# Pagy on Docker

This dir contains a few files to setup a ruby development environment without installing anything on your system.

You can use it to develop changes, run tests and check a live preview of the documentation.

It also includes the docker files to setup a javascript testing environment using `cypress`. See the [E2E Environment](#e2e-environment) below

## Ruby Dev Environment

The pagy docker environment has been designed to be useful for developing:

- It provides the infrastructure required (right version of ruby, jekyll server, env variables, tests, etc.) without the hassle to install and maintain anything in your system
- The local `pagy` dir is mounted at the container dir `/opt/project` so you can edit the files in your local pagy dir or in the container: they are the same files.
- The gems are installed in the container `BUNDLE_PATH=/usr/local/bundle` and that dir is `chown`ed to your user, and mounted as the docker volume `pagy_bundle`. You can use the `bundle` command and it will be persisted in the volume, no need to rebuild the image nor pollute your own system.
- Your container user `HOME` is preserved in the `pagy_user_home` volume, so you can even get back to the shell history in future sessions.

### Prerequisites

- recent `docker`
- recent `docker-compose`
- basic knowledge of docker/docker-compose

### Build

You have a couple of alternatives:

1. (recommended) Permanently set a few environment variables about your user in your IDE or system or in a `pagy-on-docker/.env` file (it will be easier later):
   - the `GROUP` name (get it with `id -gn` in the terminal)
   - if `echo $UID` return nothing, then set the `UID` (get it with `id -u` in the terminal)
   - if `echo $GID` return nothing, then set the `GID` (get it with `id -g` in the terminal)
   - (Notice: you can also specify a few other variables used in the `docker-compose.yml` file.)

  ```sh
  cd pagy-on-docker
  docker-compose build pagy pagy-jekyll
  ```

2. Just set them with the command (you will have to set them each time you will have to build or do other stuff) For example:

  ```sh
  cd pagy-on-docker
  GROUP=$(id -gn) UID=$(id -u) GID=$(id -g) docker-compose build pagy pagy-jekyll
  ```

  You need to run this only once usually, when you build the images. After that you just run the containers (see below).

### Run

Run the containers from the `pagy-on-docker` dir:

```sh
docker-compose up pagy
docker-compose up pagy-jekyll # for the documentation site
docker-compose up pagy pagy-jekyll # for both pagy and the documentation site
```
Then:

1. Open a terminal in the pagy container:
   - if the container is already up, run bash in the same container `docker-compose exec pagy bash`
   - or `docker-compose run --rm pagy bash` to run it in a different container

2. `bundle install` to install the gems into the `pagy_bundle` volume.

At this poin the setup is completed, so you can run `irb -I lib -r pagy` from the container in order to have `pagy` loaded and ready to try.

Run all the tests by simply running `rake` without arguments: it will run the `test`, `rubocop`, `coverge_summary` and `manifest:check` tasks.

Notice: Certain tests must run in an isolated ruby process. For example, certain extras override the core pagy methods and we need to test how pagy works with or without the extra, or with many extras at the same time. You can get the full list of of all the test tasks (and test files that each task run) with `rake -D test_*`

Check the details (not only the summary) of the coverage by running in the container:

```sh
HTML_REPORTS=true rake
```

Then check it at `http://0.0.0.0:63342/pagy/coverage`.

The `pagy-jekyll` service runs the jekyll server so you can edit the docs files from the local `pagy` dir and have a real-time preview of your changes at `http://localhost:4000`. You don't even need to reload the page in the browser to see the change you do in the `*.md` page file.

If you are serious about developing, you can integrate this environment with some good IDE that provides docker and ruby integration. I currently use it for all the basic pagy development, fully integrated with [RubyMine](https://www.jetbrains.com/ruby/?from=https%3A%2F%2Fgithub.com%2Fddnexus%2Fpagy).

### Clean up

When you want to get rid of everything related to the `pagy` development on your system:

- `rm -rf /path/to/pagy`
- `docker rmi pagy pagy-gh-pages` or `docker rmi pagy:4 pagy-gh-pages` if you don't want to remove other versions (e.g. `pagy:3`)
- `docker volume rm pagy_bundle pagy_user_home pagy_docs_site`
- `docker system prune` (not pagy related but good for reclaiming storage space from docker)

### Caveats

- If you use different pagy images for different pagy versions/branches:
    - Remember to checkout the right branch before using it
    - If you get some problem running the tests you might need to `rm -rf coverage`

## E2E Environment

Pagy provides quite a few helpers that render the pagination elements for different js-frameworks on the server side or on the client side (with improved performance). They are tested with a sinatra/rackup/puma ruby app and  [Cypress](https://www.cypress.io).

If you determine that you need to run the E2E tests, here are three different ways to run them:

### 1. Github Actions

Just create a PR and all the tests (including the cypress tests) will run on GitHub. Use this option if you don't need to write any js code or tests interactively and the ruby tests pass.

### 2. Run Cypress Locally On Your System

_**Notice**: This is the easiest way to run/edit the E2E tests but it requires `node` and adds quite a few modules to it._

- [Install Cypress](https://docs.cypress.io/guides/getting-started/installing-cypress)
- `bundle install`
- `rackup test/e2e/pagy_app.rb`
- Open and run your Cypress tests `./node_modules/.bin/cypress open`

### 3. Build Pagy Cypress

_**Notice**: This is a big download, but all the cypress stuff is contained in the docker space, i.e. you can remove it completely when you finished without any left-over in your system. It is functional but the interactive part may miss a few minor features._

Check your user id with:

```sh
id -u
```

If it is `1000` you are all setup for building the container. If it is any other id, you should first edit the `pagy-on-docker/docker-compose.yml` file and switch (i.e. commenting/uncommenting) the `pagy-cypress.build.dockerimage` entries so they will look like this:

```yml
...
    # switch between the following 2 lines if your user id is 1000 or not
    # dockerfile: pagy-cypress-uid1000.dockerfile
    dockerfile: pagy-cypress.dockerfile
...
```

Then save the file.

Regardless your id, the rest of the build steps will be almost identical to the [Build](#build) section above.

The ony difference is that you must replace the command `docker-compose build pagy pagy-jekyll` with `docker-compose build pagy-cypress`.

All the rest (including ENV variables) is exactly the same.

#### Run the tests in headless mode

If you just want to run the tests, run the following command from the `pagy-on-docker` dir:

```sh
docker-compose -f docker-compose.yml -f run-test-app.yml up pagy pagy-cypress
```

That will run all the tests with the built in `electron` browser in headless mode and print a report right on the screen. It will also create a video for each test file run in the `test/e2e/cypress/videos`. In case of test failures you will also have screenshots images in `test/e2e/cypress/screenshots` showing you exactly what was on the page of the browser at the moment of the failure.

#### Run the tests in interactive mode

If you want to open and interact the cypress desktop app as it was installed in your local system, and you are lucky enough to run with user id `1000` on an ubuntu system, you can just run it with the command below without custoizing anything.

If not, (i.e. different uid or different OS or version) you should first read the comments in the `pagy-on-docker/open-cypress.yml` file and customize it a bit according to your OS need.

Then run it with:

```sh
docker-compose -f docker-compose.yml -f run-test-app.yml -f open-cypress.yml up pagy pagy-cypress
```

That will open the cypress desktop app and will allow you to interact with it.
