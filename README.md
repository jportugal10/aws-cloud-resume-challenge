# aws-cloud-resume-challenge




<img width="943" alt="Architecture Diagram" src="https://github.com/jportugal10/aws-cloud-resume-challenge/assets/99933469/a8f52bf1-02ec-44eb-8059-8633c8ebc22c">




Tech Stack used: 

* S3
* CloudFront
* Certificate Manager
* Route 53
* Lambda
* DyanmoDB
* Terraform


- Uploaded index.html to an S3 Bucket.

- Created a CloudFront Distribution that points to the S3 and has index.html set as the default root object

- Registered domain via Route 53 and created a Hosted Zone for DNS records. Created A record that points to URL.

- Created Lambda function with Python and boto3 to create a viewer count partnered with DynamoDB.

- Set up IAM Policies and roles for security purposes.

- Initialized IaC for backend CI/CD via Terrform and AWS CLI. (See Github repo for code)
