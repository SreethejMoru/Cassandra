variable "ami_id" {
  description = "The ID of the AMI to use for instances"
  type        = string
    default = "ami-058bd2d568351da34"

}

variable "instance_type" {
  description = "The type of EC2 instances"
  type        = string
    default = "t2.micro"

}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default = "cassandra"

}

variable "minion_count" {
  description = "The number of Salt minions to create"
  type        = number
    default = 3  # Adjust as needed

}

variable "private_key_path" {
  description = "The path to the private key for SSH access."
  type        = string
  default     = "/home/sreethejmoru/Downloads/cassandra.pem"
}