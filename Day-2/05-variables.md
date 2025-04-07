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
