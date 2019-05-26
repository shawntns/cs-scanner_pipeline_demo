## Application Configuration

The application is configured through environment variables. The set of expected variables are defined below. Note that
the variables are mandatory unless specified otherwise.

1. `TENABLE_ACCESS_KEY`: Your Tenable.io API Access Key
2. `TENABLE_SECRET_KEY`: Your Tenable.io API Secret Key
3. `REGISTRY_NAME`: A name for your registry which will appear in the Tenable.io UI and API. This must not contain spaces.
4. `REGISTRY_URI`: The URI of your registry, for example: `http://localhost:5000` or `https://registry.yourorg.com`. Note that a port may optional be specified, but the protocol _must_ be specified.
5. `REGISTRY_USERNAME` (OPTIONAL) if you need to authenticate to your registry, supply the username in this field. *If you do not need to authenticate, do not specify this variable*.
6. `REGISTRY_PASSWORD` (OPTIONAL) if you need to authenticate to your registry, supply the password in this field. *If you do not need to authenticate, do not specify this variable*.
7. `IMPORT_INTERVAL_MINUTES` (OPTIONAL) The delay between each import for this registry, specified in _minutes_. If this variable is not defined, the application will terminate after completing a single import.

## Running the application

Run the Docker image, exposing the required configuration through environment variables.

### Example One

The following example executes a once-off import from a registry at `https://registry.mycompany.com` which requires no
credentials.

```
docker run \
    -e TENABLE_ACCESS_KEY=da304f8e5841410a6c977d04a333edb42a5e7ffdbe5e12b07e27431ee44f5ea8 \
    -e TENABLE_SECRET_KEY=97e745c0e44f0ef41a3d5a6e46485078eb486a684072bb77207e90026ce09ffc \
    -e REGISTRY_NAME=production-registry-artifactory \
    -e REGISTRY_URI=https://registry.mycompany.com \
    -it tenableio-docker-consec-local.jfrog.io/on-prem-registry-importer:latest
```

### Example Two

The following example executes a recurring import every three hours from a registry at `https://registry.mycompany.com`.
When importing from registry, a username and password are provided to the registry.

```
docker run \
    -e TENABLE_ACCESS_KEY=da304f8e5841410a6c977d04a333edb42a5e7ffdbe5e12b07e27431ee44f5ea8 \
    -e TENABLE_SECRET_KEY=97e745c0e44f0ef41a3d5a6e46485078eb486a684072bb77207e90026ce09ffc \
    -e REGISTRY_NAME=production-registry-artifactory \
    -e REGISTRY_URI=https://registry.mycompany.com \
    -e REGISTRY_USERNAME=build \
    -e REGISTRY_PASSWORD=Password123 \
    -e IMPORT_INTERVAL_MINUTES=180 \
    -it tenableio-docker-consec-local.jfrog.io/on-prem-registry-importer:latest
```
