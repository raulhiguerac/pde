some problems when destroying google_service_networking_connection https://github.com/hashicorp/terraform-provider-google/issues/16275

docker login -u _json_key --password-stdin https://us-central1-docker.pkg.dev < ../credentials/proyectopde-8185a4f5800c.json

docker tag custom-airflow:1.0 us-central1-docker.pkg.dev/proyectopde/prod/custom-airflow:1.0

docker push us-central1-docker.pkg.dev/proyectopde/prod/custom-airflow:1.0

https://stackoverflow.com/questions/27068596/how-to-include-files-outside-of-dockers-build-context

https://cloud.google.com/composer/docs/concepts/versioning/composer-versions

kubectl exec -it $(kubectl get pods -n airflow | grep webserver | awk '{print $1}') -c webserver -n airflow -- bash