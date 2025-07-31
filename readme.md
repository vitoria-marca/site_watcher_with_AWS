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
![Route Description](https://prnt.sc/qX_kdDvhULke)
Both must have been connected to your VPC. Let's create the EC2.
You can create your EC2 with the tags you want and then select Ubuntu's AMI. Select your key pair or create one. At Network Settings, add these configs at security group:
![Security Group configuration](https://prnt.sc/yCdJbNXlvgQm)
Then, connect your VPC and public subnet by clicking the **edit** buttom at Network Settings. You can choose between creating an Elastic IP or turning on the option "Auto-assign public IP".
In advanced setings, put the IAM you created.

## Second Step >> set up nginx server
Connect into your server:
```
ssh -i your-key-pair.pem ubuntu@your.public.ec2.ip
```
Copy the files that are in this repository into the server
```

```