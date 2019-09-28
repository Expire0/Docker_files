


cd /root/
rm -rf expire0_priv/ 
ssh-agent bash -c ' ssh-add  /root/.ssh/id_git; git clone git@github.com:Expire0/expire0_priv.git'
cd /root/Docker_files/bind9 
cp ../../expire0_priv/bind-configs/configs.zip .
unzip -P $2 configs.zip 

docker build -t powserve:dns$1 . 
echo "images build complete. Cleaning up the repo"
rm -rf configs.zip
rm -rf data 
rm -rf  configs
