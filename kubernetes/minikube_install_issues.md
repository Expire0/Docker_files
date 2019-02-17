#MiniKube installation issues

I wanted to document some of the issues I had installing minikube. I also want to note some of the issues 
may be related to how AWS is setup and Centos repos. 

I was following the instructions at https://kubernetes.io/docs/tasks/tools/install-minikube/ which seem straight forward. 
My problem really started here https://kubernetes.io/docs/tasks/tools/install-minikube/#install-kubectl . 

Error #1
Error creating host:: sudo systemctl -f restart docker: Process exited with status 1
error creating file at /usr/bin/kubeadm: open /usr/bin/kubeadm: permission denied

Thoughts: I think this was partially my own problem and partically AWS. Neither here or there. I was unable to determine my issue for quite some time. It turned out to be a issue with the root password being expired on the cloud server. I was able to sudo su to root. But Minikube wanted to ssh into root which it couldnt because of the expired password. It would have been great for the minikube documentation could mention we need to have a valid login for the root user. Let's say root logins were disabled? This will fail everytime. I reference this issue on github which didnt help much but it may help others out there https://github.com/kubernetes/minikube/issues/1952 . I also want to know that I wasn't sure which user I should run minikube as. This was not noted in the documentation. 

Error #2
Failed to connect socket to '/var/run/libvirt/libvirt-sock'

Once I was able to resolve Error #1. I moved on to trying to run minikube with the kvm driver.So i thought this would be possible on a remote cloud server. I was completed wrong in regards to this AWS server I was using. I followed the instructions at https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#kvm2-driver and in the end received the error message. I finally figured out that I needed to start libvirtd with systemctl . It would have been nice to have this documented somewhere and i plan on doing a pull request to make it so. 

Thoughts: So you thought i was able to overcome Error #2, nope. The issue with this error is that I could not run minikube with the kvm driver because virtualiation was not enabled at the host level. So I found that I needed to use the none driver instead "minikube start --vm-driver none"

Error #3
Application conflicts 

For some odd reason. I thought I needed to install kubeadm,kubelet and kubectl manually using 
https://kubernetes.io/docs/setup/independent/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl . I was wrong in my thinking because after trying to run "minikube start" it generated all kinds of unknown errors so I uninstalled each of them. I also had a conflict initially because I installed kubernetes from the Centos Repository . The take away from this is dont use the Centos Repository for anything if you plan on using minikube. 

Error #4
kubelet fails with error "misconfiguration: kubelet cgroup driver: "cgroupfs" is different from docker cgroup driver: "systemd"

Thoughts: This error took me about a 90 minutes to resolve. The CentOS based Docker comes with "systemd" as "cgroup-driver" (--cgroup-driver=systemd).
And "kubelet" service use "cgroupfs" in the "/etc/systemd/system/kubelet.service.d/10-kubeadm.conf" file as "cgroup-driver" (--cgroup-driver=cgroupfs).

Solution: To overcome this issue I had to uninstall docker that  was part of the Centos repository and install Docker Ce. Per https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository . Again dont user the Centos repos for anything relating to minikube
