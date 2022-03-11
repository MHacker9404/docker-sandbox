docker build -f azure-cli.dockerfile -t az-cli:dotnet-6  -t prbservicesllc/az-cli:dotnet-6 -t prbservicesllc/az-cli:latest .
docker push prbservicesllc/az-cli:dotnet-6 
docker push prbservicesllc/az-cli:latest