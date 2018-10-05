resource "aws_instance" "cloudmapper3" {
ami = "ami-04681a1dbd79675a5"
instance_type = "t3.medium"
vpc_security_group_ids = ["${aws_security_group.secgrpT1.id}"]
subnet_id = "${aws_subnet.subnetT1.id}"
key_name = "test-key-pair"
user_data = <<EOF
#!/bin/bash
su - ec2-user
sudo /bin/yum clean all
sudo /bin/yum update -y 
sudo yum install python3 -y
sudo easy_install pip -y
sudo easy_install virtualenv
sudo yum install -y wget
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod 755 jq-linux64
sudo mv jq-linux64 /usr/bin/
sudo yum install autoconf automake libtool python3-devel.x86_64 python3-tkinter jq awscli git -y
git clone https://github.com/duo-labs/cloudmapper
sudo pip install  pyjq
mkdir ~/.aws
echo [default] > ~/.aws/config
echo region = us-east-1 >> ~/.aws/config

cd cloudmapper/
sudo pip install pipenv
sed -i -e 's/127.0.0.1/0.0.0.0/' commands/webserver.py
pipenv install --skip-lock
pipenv shell
python cloudmapper.py prepare --config config.json.demo --account demo
python cloudmapper.py webserver

#If demo is intended upper rows are all we need


cat <<EOK >> /cloudmapper/config.json.tolga
{  "accounts":
    [
        {"id": "233177744977", "name": "233177744977", "default": true}
    ],
    "cidrs":
    {
        "1.1.1.1/32": {"name": "SF Office"},
        "2.2.2.2/28": {"name": "NY Office"}
    }
}
EOK

cat <<EOK2 >> /home/ec2-user/skript
sudo yum install python3 -y
sudo easy_install pip -y
sudo easy_install virtualenv
sudo yum install -y wget
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod 755 jq-linux64
sudo mv jq-linux64 /usr/bin/
sudo yum install autoconf automake libtool python3-devel.x86_64 python3-tkinter jq awscli git -y
git clone https://github.com/duo-labs/cloudmapper
sudo pip install  pyjq
mkdir ~/.aws
echo [default] > ~/.aws/config
echo region = us-east-1 >> ~/.aws/config

cd cloudmapper/
sudo pip install pipenv
sed -i -e 's/127.0.0.1/0.0.0.0/' commands/webserver.py
pipenv install --skip-lock
pipenv shell
python cloudmapper.py prepare --config config.json.demo --account demo
python cloudmapper.py webserver

#If demo is intended upper rows are all we need
# AFter cleaning the processes following commands can be executed to bring up another environment as a graphic
pipenv shell
python cloudmapper.py collect --account 233177744977 
python cloudmapper.py prepare --config config.json.tolga --account 233177744977
python cloudmapper.py webserver


EOK2
EOF


tags {
 Name = "cloudmapperT3"
}
}

output "public_ip2" {
value = "${aws_instance.cloudmapper3.public_ip}"
}

