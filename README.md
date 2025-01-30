# Домашнее задание к занятию "`Основы Terraform. Yandex Cloud`" - `Маркин Алексей`

### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.8.4

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.
5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;
8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
- ответы на вопросы.


## Решение 1

Были допущены ошибки(опечатки) в блоке resource "yandex_compute_instance" "platform" 

После исправления блок выглядит так:
```
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
```

![Вопрос1](https://github.com/Markin-AI/ter-02/blob/main/img/1-1.png)

![Вопрос1](https://github.com/Markin-AI/ter-02/blob/main/img/1-2.png)

Параметр ```preemptible = true``` применяется в том случае, если нужно сделать виртуальную машину прерываемой, то есть возможность остановки ВМ в любой момент. Применятся если с момента запуска машины прошло 24 часа либо возникает нехватка ресурсов для запуска ВМ. ВМ может быть отключена в любой момент.

Параметр ```core_fraction=5``` указывает гарантированную производительность ядра в процентах. Указывается для экономии ресурсов.


---

### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

## Решение 2

main.tf после объявления переменных

```
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
```

variables.tf после объявления переменных

```
###VM vars

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Ubuntu version"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "instance name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}

variable "vm_web_cores" {
  type        = string
  default     = "2"
  description = "vCPU numbers"
}

variable "vm_web_memory" {
  type        = string
  default     = "1"
  description = "VM memory GB"
}

variable "vm_web_core_fraction" {
  type        = string
  default     = "20"
  description = "vCPU core fraction"
}
```

![Вопрос2](https://github.com/Markin-AI/ter-02/blob/main/img/2.png)

---

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
3. Примените изменения.

## Решение 3

<details>

<summary>main.tf</summary>

```
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = var.vpc_name_b
  zone           = var.default_zone_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_b
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform-web" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
data "yandex_compute_image" "ubuntu2" {
  family = var.vm_db_family
}

resource "yandex_compute_instance" "platform-db" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  zone        = var.default_zone_b
  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```
</details>

<details>

<summary>variables.tf</summary>

```
###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_cidr_b" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vpc_name_b" {
  type        = string
  default     = "develop-b"
  description = "VPC network & subnet name"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tv/k8eZPA441HJ+BwGoF02XXNadGqDQ4DWmB0JgAF markin@markin-VirtualBox"
  description = "ssh-keygen -t ed25519"
}


```
</details>

<details>

<summary>vms_platform.tf</summary>

```
###VM vars

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Ubuntu version"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "instance name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}

variable "vm_web_cores" {
  type        = string
  default     = "2"
  description = "vCPU numbers"
}

variable "vm_web_memory" {
  type        = string
  default     = "1"
  description = "VM memory GB"
}

variable "vm_web_core_fraction" {
  type        = string
  default     = "20"
  description = "vCPU core"
}

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Ubuntu version"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "instance name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}

variable "vm_db_cores" {
  type        = string
  default     = "2"
  description = "vCPU numbers"
}

variable "vm_db_memory" {
  type        = string
  default     = "2"
  description = "VM memory GB"
}

variable "vm_db_core_fraction" {
  type        = string
  default     = "20"
  description = "vCPU core"
}
```
</details>

![Вопрос3](https://github.com/Markin-AI/ter-02/blob/main/img/3.png)

---

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

## Решение 4

```
output "web" {
  value = {
    instance_name = yandex_compute_instance.platform-web.name
    external_ip   = yandex_compute_instance.platform-web.network_interface.0.nat_ip_address
    fqdn          = yandex_compute_instance.platform-web.fqdn
  }
}

output "db" {
  value = {
    instance_name = yandex_compute_instance.platform-db.name
    external_ip   = yandex_compute_instance.platform-db.network_interface.0.nat_ip_address
    fqdn          = yandex_compute_instance.platform-db.fqdn
  }
}
```

![Вопрос4](https://github.com/Markin-AI/ter-02/blob/main/img/4.png)

---


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

## Решение 5

```
locals {
  project = "netology-develop-platform"
  vm_1 = "web"
  vm_2 = "db"
  web_name = "${local.project}-${local.vm_1}"
  db_name = "${local.project}-${local.vm_2}"
}
```

![Вопрос5](https://github.com/Markin-AI/ter-02/blob/main/img/5.png)

---

### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

## Решение 6

<details>

<summary>variables.tf</summary>

```
###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "default_cidr_b" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vpc_name_b" {
  type        = string
  default     = "develop-b"
  description = "VPC network & subnet name"
}

###ssh vars

/*
variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tv/k8eZPA441HJ+BwGoF02XXNadGqDQ4DWmB0JgAF markin@markin-VirtualBox"
  description = "ssh-keygen -t ed25519"
}
*/

variable "vm_resources" {
  type        = map(map(number))
  description = "Resources map for VMs"
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
}

variable "vm_metadata" {
  type        = map(string)
  description = "Metadata map for VMs"
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Tv/k8eZPA441HJ+BwGoF02XXNadGqDQ4DWmB0JgAF markin@markin-VirtualBox"
  }
}
```
</details>

<details>

<summary>vms_platform.tf.tf</summary>

```
###VM vars

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Ubuntu version"
}
/*
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "instance name"
}
*/

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}
/*
variable "vm_web_cores" {
  type        = string
  default     = "2"
  description = "vCPU numbers"
}

variable "vm_web_memory" {
  type        = string
  default     = "1"
  description = "VM memory GB"
}

variable "vm_web_core_fraction" {
  type        = string
  default     = "20"
  description = "vCPU core"
}
*/
variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Ubuntu version"
}
/*
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "instance name"
}
*/
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}
/*
variable "vm_db_cores" {
  type        = string
  default     = "2"
  description = "vCPU numbers"
}

variable "vm_db_memory" {
  type        = string
  default     = "2"
  description = "VM memory GB"
}

variable "vm_db_core_fraction" {
  type        = string
  default     = "20"
  description = "vCPU core"
}
*/
```
</details>

![Вопрос6](https://github.com/Markin-AI/ter-02/blob/main/img/6.png)

---

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

## Решение 7

1. local.test_list[1]

2. length (local.test_list)

3. local.test_map["admin"]

![Вопрос7](https://github.com/Markin-AI/ter-02/blob/main/img/7-1.png)

4. "${ local.test_map.admin } is ${ keys(local.test_map)[0] } for ${ keys(local.servers)[1] } server based on OS ${ local.servers.production.image } with ${ local.servers.production.cpu } vcpu, ${ local.servers.production.ram } ram and ${ length(local.servers.production.disks) } virtual disks "

![Вопрос7](https://github.com/Markin-AI/ter-02/blob/main/img/7-2.png)

---

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.

## Решение 8

```
variable "test" {
  type          = list(map(list(string)))
  default       = [
    {
      "dev1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
        "10.0.1.7"
      ]
    },
    {
      "dev2" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
        "10.0.2.29"
      ]
    },
    {
      "prod1" = [
        "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
        "10.0.1.30"
      ]
    }
  ]
}
```

![Вопрос8](https://github.com/Markin-AI/ter-02/blob/main/img/8.png)

---

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

## Решение 9

![Вопрос9](https://github.com/Markin-AI/ter-02/blob/main/img/9-1.png)

![Вопрос9](https://github.com/Markin-AI/ter-02/blob/main/img/9-2.png)

![Вопрос9](https://github.com/Markin-AI/ter-02/blob/main/img/9-3.png)

![Вопрос9](https://github.com/Markin-AI/ter-02/blob/main/img/9-4.png)

---