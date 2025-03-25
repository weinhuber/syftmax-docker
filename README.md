# 🐳 SyftMax Docker Image

This repository provides a prebuilt Docker image for running **SyftMax** — no manual setup or compilation required.

---

## ⚙️ 1. Download Docker Image

Download the Docker image: 


👉 [https://unioxfordnexus-my.sharepoint.com/:u:/g/personal/coml0935_ox_ac_uk/EUZT-5MjsERIoWTg_gAzbfUB9CVyTNH5m6mLNW4B-9nF-Q?e=22XKt8](https://unioxfordnexus-my.sharepoint.com/:u:/g/personal/coml0935_ox_ac_uk/EUZT-5MjsERIoWTg_gAzbfUB9CVyTNH5m6mLNW4B-9nF-Q?e=22XKt8)

---

## 🐋 2. Install Docker

Download and install Docker from the official site:  

👉 [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

After installation, verify it works:

```bash
docker --version
```

---

## 📦 3. Load the Docker Image

```bash
docker load < syftmax_example.tar.gz
```

> ⏳ This might take a while

---

## 🚀 4. Start the Docker Container

Launch the container with a shell:

```bash
docker run -it syftmax_example bash
```

> ⏳ This might take a while too

---

## 🧪 5. Run SyftMax Inside the Container

Once inside the container, run:

```bash
/usr/local/bin/Syftmax -f formula.ltlf -p partition.part
```

> 📁 You can use Nano/Vim to manipulate `formula.ltlf` and `partition.part` inside the container.
> We use the standard syntax, as introduced in the lecture with `X` and `WX`.

---

## ❌ 6. Exit the Container

Run:


```bash
exit
```

or `CTRL` + `D` to quit the Docker shell and stop the container.

---

## ✅ That’s It!

You’re all set to use **SyftMax** via Docker with zero setup on your host system.
Good luck with your exam!
