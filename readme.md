# Welcome to Site Watcher!

Site Watcher is a solution that uses **AWS combined to nginx and Discord webhook** to send you notifications about your website status.

# Prerequisites

 - [ ] AWS Account
 - [ ] Linux environment 
 - [ ] Discord Account

##  First Step >> Prerequisites

### Discord
Create your account if you do not have one. Then, create a server and go to **Server Configs** > Integrations > Webhook. Copy and let's store it in a safer way.
**Go to AWS > Systems Manager > Aplication Tools > Parameter Store**. 
Name: I used '/secrets/discord-webhook/'
Type: SecureString
Value: Paste the link you've copy.
Let's create a role to use in your EC2 and allow it to access/read the parameters we've set.
**IAM > Access management > Roles > Create**
Service: EC2, next
Permissions policies: AmazonSSMReadOnlyAccess

### AWS

First, create your VPC. It must have at least *1 private subnet and 1 public subnet*.
Then, create a **route table** connected in a internet gateway with these destinations:
[Route Description] https://prnt.sc/qX_kdDvhULke
Both must have been connected to your VPC. Let's create the EC2.
You can create your EC2 with the tags you want and then select Ubuntu's AMI. Select your key pair or create one. At Network Settings, add these configs at security group:
[Security Group configuration] https://prnt.sc/yCdJbNXlvgQm
Then, connect your VPC and public subnet by clicking the **edit** buttom at Network Settings. You can choose between creating an Elastic IP or turning on the option "Auto-assign public IP".
In advanced setings, put the IAM you created.

## Second Step >> set up nginx server
Copy the files that are in this repository into the server
```
scp -i your-key-pair.pem helloworld.html watcher.sh ubuntu@your.public.ec2.ip:/home/ubuntu
```
Connect into your server:
```
ssh -i your-key-pair.pem ubuntu@your.public.ec2.ip
```
Now, let's configure nginx and aws cli so we can touch the webhook we store in aws.
```
sudo apt update -y 
sudo apt install -y curl unzip nginx gettext

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
Now, let's use the webhook and your url as an environment variable.
```
nano .env
```
Then:
```
WEBHOOK=$(/usr/local/bin/aws ssm get-parameter \
    --name "/secrets/discord-webhook" \
    --with-decryption \
    --query "Parameter.Value" \
    --output text)
MY_IP="http://your.url.here.here"
```
You can check if it worked typing ```echo $WEBHOOK``` and ```echo $MY_IP```. You can also change the permissions ```chmod 600 .env```
Now, copy the .html file to nginx homepage
```
sudo mv helloworld.html /var/www/html/index.html
```
Let's set the routines:
``` sudo crontab -e ``` and ```* * * * * /home/ubuntu/watcher.sh >> /var/log/watcher-cron.log 2>&1 ```

