# Modules

The advantage of using Terraform modules in your infrastructure as code (IaC) projects lies in improved organization, reusability, and maintainability. Here are the key benefits:

1. **Modularity**: Terraform modules allow you to break down your infrastructure configuration into smaller, self-contained components. This modularity makes it easier to manage and reason about your infrastructure because each module handles a specific piece of functionality, such as an EC2 instance, a database, or a network configuration.

2. **Reusability**: With modules, you can create reusable templates for common infrastructure components. Instead of rewriting similar configurations for multiple projects, you can reuse modules across different Terraform projects. This reduces duplication and promotes consistency in your infrastructure.

3. **Simplified Collaboration**: Modules make it easier for teams to collaborate on infrastructure projects. Different team members can work on separate modules independently, and then these modules can be combined to build complex infrastructure deployments. This division of labor can streamline development and reduce conflicts in the codebase.

4. **Versioning and Maintenance**: Modules can have their own versioning, making it easier to manage updates and changes. When you update a module, you can increment its version, and other projects using that module can choose when to adopt the new version, helping to prevent unexpected changes in existing deployments.

5. **Abstraction**: Modules can abstract away the complexity of underlying resources. For example, an EC2 instance module can hide the details of security groups, subnets, and other configurations, allowing users to focus on high-level parameters like instance type and image ID.

6. **Testing and Validation**: Modules can be individually tested and validated, ensuring that they work correctly before being used in multiple projects. This reduces the risk of errors propagating across your infrastructure.

7. **Documentation**: Modules promote self-documentation. When you define variables, outputs, and resource dependencies within a module, it becomes clear how the module should be used, making it easier for others (or your future self) to understand and work with.

8. **Scalability**: As your infrastructure grows, modules provide a scalable approach to managing complexity. You can continue to create new modules for different components of your architecture, maintaining a clean and organized codebase.

9. **Security and Compliance**: Modules can encapsulate security and compliance best practices. For instance, you can create a module for launching EC2 instances with predefined security groups, IAM roles, and other security-related configurations, ensuring consistency and compliance across your deployments.

### **Why Do We Need to Write `output` in Both the Module and `main.tf`?**  

When using **Terraform modules**, outputs are defined **twice**:  
1️⃣ **Inside the module** – To expose values from the module.  
2️⃣ **In `main.tf` (outside the module)** – To reference and use those values in the root module.  

---

## **🔹 How Outputs Work in Modules**
A module in Terraform is like a reusable component. When you use a module, it **does not automatically expose its internal values** to the root module. Instead, you must explicitly define outputs inside the module and reference them outside.

---

### **🔹 Example: Without Outputs**
#### **`modules/ec2/main.tf` (Inside the Module)**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```
- This module **creates an EC2 instance**.  
- But **there's no way to access its attributes (e.g., `public_ip`) from the root module**.  

---

### **🔹 Step 1: Define `output` Inside the Module**
#### **`modules/ec2/outputs.tf` (Inside the Module)**
```hcl
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
```
✔ **This makes `public_ip` available within the module.**  
✔ **But the root module still can't access it yet.**  

---

### **🔹 Step 2: Reference the Module in `main.tf`**
#### **`main.tf` (Root Module)**
```hcl
module "ec2_instance" {
  source = "./modules/ec2"
}
```
- This **calls the module**, but it does not display `public_ip` yet.

---

### **🔹 Step 3: Define `output` in `main.tf`**
#### **`main.tf` (Root Module)**
```hcl
output "ec2_instance_public_ip" {
  value = module.ec2_instance.instance_public_ip
}
```
✔ This **retrieves the `public_ip` from the module’s outputs** and displays it in Terraform output.

---

## **🔹 Why Define Outputs Twice?**
| **Location**  | **Purpose** |
|--------------|------------|
| **Inside Module (`modules/ec2/outputs.tf`)** | Allows the module to expose specific values. |
| **Outside Module (`main.tf`)** | Retrieves and displays those values in the root module. |

Terraform **isolates modules** to keep them reusable and independent. Without explicitly defining outputs:
- Modules **cannot leak data** unless explicitly exposed.
- Root modules **can only access what’s defined in the module’s `outputs.tf`**.

---

## **🎯 Key Takeaways**
✔ Define `output` **inside** the module to expose values.  
✔ Define `output` **outside** the module to retrieve and display those values.  
✔ This **ensures modularity and security**, preventing unnecessary data exposure.  
