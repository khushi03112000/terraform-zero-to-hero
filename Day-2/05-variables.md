# Variables

Input and output variables in Terraform are essential for parameterizing and sharing values within your Terraform configurations and modules. They allow you to make your configurations more dynamic, reusable, and flexible.

## Input Variables

Input variables are used to parameterize your Terraform configurations. They allow you to pass values into your modules or configurations from the outside. Input variables can be defined within a module or at the root level of your configuration. Here's how you define an input variable:

```hcl
variable "example_var" {
  description = "An example input variable"
  type        = string
  default     = "default_value"
}
```

In this example:

- `variable` is used to declare an input variable named `example_var`.
- `description` provides a human-readable description of the variable.
- `type` specifies the data type of the variable (e.g., `string`, `number`, `list`, `map`, etc.).
- `default` provides a default value for the variable, which is optional.

You can then use the input variable within your module or configuration like this:

```hcl
resource "example_resource" "example" {
  name = var.example_var
  # other resource configurations
}
```

You reference the input variable using `var.example_var`.

## Output Variables

Output variables allow you to expose values from your module or configuration, making them available for use in other parts of your Terraform setup. Here's how you define an output variable:

```hcl
output "example_output" {
  description = "An example output variable"
  value       = resource.example_resource.example.id
}
```

In this example:

- `output` is used to declare an output variable named `example_output`.
- `description` provides a description of the output variable.
- `value` specifies the value that you want to expose as an output variable. This value can be a resource attribute, a computed value, or any other expression.

You can reference output variables in the root module or in other modules by using the syntax `module.module_name.output_name`, where `module_name` is the name of the module containing the output variable.

For example, if you have an output variable named `example_output` in a module called `example_module`, you can access it in the root module like this:

```hcl
output "root_output" {
  value = module.example_module.example_output
}
```

This allows you to share data and values between different parts of your Terraform configuration and create more modular and maintainable infrastructure-as-code setups.

Great question — this shows clarity of thought!

## Short Answer:
→ No, Terraform is *not* a dynamically typed language in the traditional sense.  
Terraform (HashiCorp Configuration Language - HCL) is a *declarative* language, not a general-purpose programming language.

---

## What does that mean?

| Term | Meaning |
|------|---------|
| *Dynamically Typed* | Data types of variables are determined at runtime (like Python, JavaScript). |
| *Statically Typed* | Data types are defined at compile time (like Java, Go, C++). |
| *Terraform / HCL* | Declarative — focuses on describing *what* resources you want, not *how* to build them. But variable types can be optionally declared for safety. |

---

## In Terraform:

### By default:
Terraform variables are *dynamically typed*.  
If you don’t specify a type → Terraform tries to infer the type based on the value you pass.

Example:
```hcl
variable "instance_name" {}
```
Here, type is not enforced — any value can be passed.

---

## But — Terraform *supports* static typing (optional)

If you want to enforce the type:
```hcl
variable "instance_name" {
  type = string
}

variable "instance_tags" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}
```

---

## Final Conclusion:

| Terraform Behaviour | Explanation |
|--------------------|-------------|
| By default | Dynamically typed (no strict type checking). |
| Recommended | Use *type constraints* for production code to avoid errors. |
| Nature of Language | Declarative, not programming oriented — focuses on infrastructure configuration. |

---

## Summary Line for Interview:
> "Terraform is a declarative language — by default variables are dynamically typed, but it supports optional static typing for better safety and validation."

### **Can We Pass Variables from CLI in Terraform?**  
No, you **do not need to hardcode variable values** in the root module's `main.tf`. You **can pass variable values from the CLI** using different methods.

---

## **🔹 Ways to Pass Variables in Terraform**
There are multiple ways to provide values for Terraform variables:

| **Method** | **How to Use It** | **Pros & Cons** |
|------------|----------------|----------------|
| **1️⃣ Hardcode in `main.tf`** | `variable "instance_type" { default = "t2.micro" }` | ❌ Not flexible, hard to change. |
| **2️⃣ `terraform.tfvars` File** | Create a file `terraform.tfvars` with `instance_type = "t3.medium"` | ✅ Good for defaults, ❌ Not dynamic. |
| **3️⃣ CLI Arguments (`-var`)** | `terraform apply -var="instance_type=t3.large"` | ✅ Flexible, ❌ Not stored for reuse. |
| **4️⃣ Environment Variables** | `export TF_VAR_instance_type="t3.micro"` | ✅ Good for automation. |
| **5️⃣ `-var-file` Option** | `terraform apply -var-file="prod.tfvars"` | ✅ Good for different environments (dev, prod). |

---

## **🔹 Example: Passing Variables via CLI**
### **Step 1: Define Variables in `variables.tf`**
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

---

### **Step 2: Use Variables in `main.tf`**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = var.instance_type
}
```

---

### **Step 3: Pass Values via CLI (No Hardcoding Required!)**
```sh
terraform apply -var="instance_type=t3.large"
```
✔ No need to hardcode values in `main.tf`.  
✔ Flexible and customizable per environment.  

---

## **🔹 When Should You Use Each Method?**
- ✅ **CLI (`-var`)** → When testing or passing dynamic values.  
- ✅ **Environment Variables (`TF_VAR_`)** → When using Terraform in CI/CD pipelines.  
- ✅ **Var files (`-var-file`)** → When managing different environments (dev, staging, prod).  
- ❌ **Hardcoding in `main.tf`** → Not recommended as it makes the setup inflexible.  
### **🔹 Passing Variables in Terraform via Environment Variables & `-var-file` Option**  

---

## **🔹 1️⃣ Passing Variables via Environment Variables (`TF_VAR_`)**
Terraform automatically reads environment variables **that start with `TF_VAR_`**.

### **🛠 Example: Passing an EC2 Instance Type Using Environment Variables**
#### **Step 1: Define a Variable in `variables.tf`**
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

#### **Step 2: Use the Variable in `main.tf`**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = var.instance_type
}
```

#### **Step 3: Set the Environment Variable in CLI**
```sh
export TF_VAR_instance_type="t3.medium"
```
✔ Now, Terraform will automatically pick up `instance_type = "t3.medium"` from the environment.

#### **Step 4: Run Terraform Commands**
```sh
terraform init
terraform apply  # Terraform will use the environment variable
```

#### **✅ Pros of Using Environment Variables**
✔ Useful in **CI/CD pipelines** where you can set variables dynamically.  
✔ Secure—**secrets like passwords can be set without being stored in files**.  
✔ Keeps Terraform commands **clean and simple** (no need to pass `-var` each time).  

#### **❌ Cons**
❌ Not easily visible—debugging can be harder if a value is missing.  
❌ If the terminal session resets, you have to set the variable again.

---

## **🔹 2️⃣ Passing Variables via `-var-file` Option**
Terraform allows defining variables in a `.tfvars` file and passing them at runtime using `-var-file`.

### **🛠 Example: Using a `terraform.tfvars` File**
#### **Step 1: Create a `terraform.tfvars` File**
Create a file named `terraform.tfvars` and define variables inside:
```hcl
instance_type = "t3.large"
```

#### **Step 2: Run Terraform with `-var-file`**
```sh
terraform apply -var-file="terraform.tfvars"
```
✔ This tells Terraform to read values from `terraform.tfvars`.

---

### **🛠 Example: Using Multiple Environment-Specific Var Files**
You can create **different `.tfvars` files** for each environment:

#### **🔹 `dev.tfvars`**
```hcl
instance_type = "t2.micro"
```
#### **🔹 `prod.tfvars`**
```hcl
instance_type = "t3.large"
```

Now, when running Terraform for **different environments**, you can specify the correct `.tfvars` file:
```sh
terraform apply -var-file="dev.tfvars"   # Uses dev settings
terraform apply -var-file="prod.tfvars"  # Uses prod settings
```

#### **✅ Pros of `-var-file`**
✔ Best for **managing different environments (dev, staging, prod, etc.)**.  
✔ Keeps variables **organized and reusable**.  
✔ Avoids exposing secrets in CLI commands.  

#### **❌ Cons**
❌ You **must remember** to specify the correct `-var-file`.  
❌ Still not ideal for **sensitive values**—use environment variables or Terraform Cloud for secrets.

---

## **🎯 Key Takeaways**
| **Method**  | **Best Use Case** | **How to Use** |
|------------|------------------|---------------|
| **Environment Variables (`TF_VAR_`)** | **CI/CD, secrets, dynamic values** | `export TF_VAR_instance_type="t3.micro"` |
| **`-var-file` Option** | **Managing multiple environments** | `terraform apply -var-file="dev.tfvars"` |
