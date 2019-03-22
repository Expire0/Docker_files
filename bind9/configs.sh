

cp ../../expire0_priv/bind-configs/configs.zip .
unzip -P $2 configs.zip 

docker build -t powserve:dns$1 . 
echo "images build complete. Cleaning up the repo"
rm -rf configs.zip
rm -rf data 
rm -rf  configs
