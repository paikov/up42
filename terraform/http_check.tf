resource "null_resource" "http_check" {
  depends_on = [data.kubernetes_service.s3www_service]

  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
      for i in {1..20}; do
        STATUS=$(curl -s -o /dev/null -w "%%{http_code}" ${local.application_url}/giphy.gif)
        if [ "$STATUS" -eq 200 ]; then
          echo "Web endpoint is reachable: HTTP 200"
          exit 0
        fi
        echo "Waiting for endpoint... HTTP status $STATUS"
        sleep 5
      done
      echo "Endpoint did not return HTTP 200 in time"
      exit 1
    EOT
  }
}

