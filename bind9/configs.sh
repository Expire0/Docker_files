

cp ../../expire0_priv/bind-configs/configs.zip .
unzip configs.zip 

docker build -t powserve:dns$1 . 
echo "images build complete. Cleaning up the repo"
rm -rf configs.zip
rm -rf data 
rm -rf  configs
