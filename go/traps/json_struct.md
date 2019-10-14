# json 解析时用到的结构体标签

- [json 解析时用到的结构体标签](#json-%e8%a7%a3%e6%9e%90%e6%97%b6%e7%94%a8%e5%88%b0%e7%9a%84%e7%bb%93%e6%9e%84%e4%bd%93%e6%a0%87%e7%ad%be)
  - [1 只有导出的结构体成员对外部程序 (json) 可见](#1-%e5%8f%aa%e6%9c%89%e5%af%bc%e5%87%ba%e7%9a%84%e7%bb%93%e6%9e%84%e4%bd%93%e6%88%90%e5%91%98%e5%af%b9%e5%a4%96%e9%83%a8%e7%a8%8b%e5%ba%8f-json-%e5%8f%af%e8%a7%81)
  - [2 结构体必须解析的字段(required 标签)](#2-%e7%bb%93%e6%9e%84%e4%bd%93%e5%bf%85%e9%a1%bb%e8%a7%a3%e6%9e%90%e7%9a%84%e5%ad%97%e6%ae%b5required-%e6%a0%87%e7%ad%be)
    - [2.1 结构体标签](#21-%e7%bb%93%e6%9e%84%e4%bd%93%e6%a0%87%e7%ad%be)
    - [2.2 json 解析嵌套域](#22-json-%e8%a7%a3%e6%9e%90%e5%b5%8c%e5%a5%97%e5%9f%9f)
    - [2.3 json 编码时会对指针解引用，使用的是实际值](#23-json-%e7%bc%96%e7%a0%81%e6%97%b6%e4%bc%9a%e5%af%b9%e6%8c%87%e9%92%88%e8%a7%a3%e5%bc%95%e7%94%a8%e4%bd%bf%e7%94%a8%e7%9a%84%e6%98%af%e5%ae%9e%e9%99%85%e5%80%bc)
    - [2.4 encoding/json.Unmarshal 实现 required 标签](#24-encodingjsonunmarshal-%e5%ae%9e%e7%8e%b0-required-%e6%a0%87%e7%ad%be)
    - [2.5 当 json 和 stream 相关时，使用 Encoder/Decoder](#25-%e5%bd%93-json-%e5%92%8c-stream-%e7%9b%b8%e5%85%b3%e6%97%b6%e4%bd%bf%e7%94%a8-encoderdecoder)
    - [2.6 定义成 json.RawMessage 的域可以延迟解析](#26-%e5%ae%9a%e4%b9%89%e6%88%90-jsonrawmessage-%e7%9a%84%e5%9f%9f%e5%8f%af%e4%bb%a5%e5%bb%b6%e8%bf%9f%e8%a7%a3%e6%9e%90)
    - [2.7 使用 interface 和 json.RawMessage 解析动态 json](#27-%e4%bd%bf%e7%94%a8-interface-%e5%92%8c-jsonrawmessage-%e8%a7%a3%e6%9e%90%e5%8a%a8%e6%80%81-json)
      - [2.7.1 实现 MarshalJson/UnmarshalJSON 接口](#271-%e5%ae%9e%e7%8e%b0-marshaljsonunmarshaljson-%e6%8e%a5%e5%8f%a3)
      - [2.7.2 将 json 解析成 interface](#272-%e5%b0%86-json-%e8%a7%a3%e6%9e%90%e6%88%90-interface)
      - [2.7.3 使用指针增加代码检查](#273-%e4%bd%bf%e7%94%a8%e6%8c%87%e9%92%88%e5%a2%9e%e5%8a%a0%e4%bb%a3%e7%a0%81%e6%a3%80%e6%9f%a5)
    - [3 gin/binding.Bind](#3-ginbindingbind)
  - [4 相关链接](#4-%e7%9b%b8%e5%85%b3%e9%93%be%e6%8e%a5)

## 1 只有导出的结构体成员对外部程序 (json) 可见

- 下面的代码中无法解析 gender 域。且编码成 json 时，gender 域不会包含

  ```go
  package main

  import (
    "encoding/json"
    "fmt"
  )

  // JSONStruct a struct to be used in json decode
  type myJSONStruct struct {
    Name   string
    Age    float64
    gender string
  }

  var rawJSON = []byte(`{
      "name": "kiki",
      "age": 18,
      "gender": "female"
  }`)

  func main() {
    var s myJSONStruct
    err := json.Unmarshal(rawJSON, &s)
    if err != nil {
      panic(err)
    }

    // [Name=kiki] [Age=18.000000] [gender=]
    fmt.Printf("[Name=%s] [Age=%f] [gender=%s]\n", s.Name, s.Age, s.gender)

    buf, err := json.Marshal(s)
    if err != nil {
      panic(err)
    }
    // [buf={"Name":"kiki","Age":18}]
    fmt.Printf("[buf=%s]\n", buf)
  }
  ```

## 2 结构体必须解析的字段(required 标签)

### 2.1 结构体标签

- **解析 json 到结构体时，不适用结构体的字段会被抛弃**。json.Unmarshal 找到结构体对应值的流程。比如给定 json 的 key 是 `name`
  - 1 查找标签名字为 name 的字段
  - 2 查找名字为 name 的字段
  - 3 查找名字为 Name 等大小写不敏感的匹配字段
  - 4 如果都没有找到，就直接忽略这个 key，不会报错。当从众多数据中只选择部分使用时非常方便。
- json 的 encode/decode 不支持 required 标签。支持的标签包括
  - `FieldName` 指定实际要查找的值
  - `omitempty` 值为空时不要包含到 JSON 中。当丢弃空属性不想包含在输出时很方便
  - `-` 跳过一些域。当查找到值时会被解析，但是不会被输出

    ```go
    package main

    import (
      "encoding/json"
      "fmt"
    )

    // JSONStruct a struct to be used in json decode
    type myJSONStruct struct {
      Name   string  `json:"nickname"`
      Age    float64 `json:"-"`
      Gender string  `json:",omitempty"`
    }

    var rawJSON = []byte(`{
        "nickname": "kiki",
        "age": 18,
        "gender": ""
    }`)

    func main() {
      var s myJSONStruct
      err := json.Unmarshal(rawJSON, &s)
      if err != nil {
        panic(err)
      }

      // [NickName=kiki] [Age=0.000000] [gender=]
      fmt.Printf("[NickName=%s] [Age=%f] [gender=%s]\n", s.Name, s.Age, s.Gender)

      buf, err := json.Marshal(s)
      if err != nil {
        panic(err)
      }
      // [buf={"nickname":"kiki"}]
      fmt.Printf("[buf=%s]\n", buf)
    }
    ```

### 2.2 json 解析嵌套域

```go
package main

import (
  "encoding/json"
  "fmt"
)

type myName struct {
  FirstName string `json:"fname"`
  LastName  string `json:"lname"`
}

// JSONStruct a struct to be used in json decode
type myJSONStruct struct {
  myName
  Age    float64 `json:"-"`
  Gender string  `json:",omitempty"`
}

var rawJSON = []byte(`{
    "fname": "kiki",
    "lname": "kity",
    "age": 18,
    "gender": ""
}`)

func main() {
  var s myJSONStruct
  err := json.Unmarshal(rawJSON, &s)
  if err != nil {
    panic(err)
  }

  // [FirstName=kiki] [LastName=kity] [Age=0.000000] [gender=]
  fmt.Printf("[FirstName=%s] [LastName=%s] [Age=%f] [gender=%s]\n", s.FirstName, s.LastName, s.Age, s.Gender)

  buf, err := json.Marshal(s)
  if err != nil {
    panic(err)
  }
  // [buf={"fname":"kiki","lname":"kity"}]
  fmt.Printf("[buf=%s]\n", buf)
}
```

### 2.3 json 编码时会对指针解引用，使用的是实际值

### 2.4 encoding/json.Unmarshal 实现 required 标签

### 2.5 当 json 和 stream 相关时，使用 Encoder/Decoder

### 2.6 定义成 json.RawMessage 的域可以延迟解析

### 2.7 使用 interface 和 json.RawMessage 解析动态 json

#### 2.7.1 实现 MarshalJson/UnmarshalJSON 接口

- JSON 模块包含两个接口 `Marshaler` 和 `Unmarshaler`。两个接口都需要一个方法

  ```go
  // Marshaler 接口定义了怎么把某个类型 encode 成 JSON 数据
  type Marshaler interface {
      MarshalJSON() ([]byte, error)
  }

  // Unmarshaler 接口定义了怎么把 JSON 数据 decode 成特定的类型数据。如果后续还要使用 JSON 数据，必须把数据拷贝一份
  type Unmarshaler interface {
      UnmarshalJSON([]byte) error
  }
  ```

  - 如果将这两个接口增加到自定义类型，就可以被编码成 JSON 或者把 JSON 解析成自定义类型
  - 一个很好的例子就是 `time.Time` 类型

    ```go
    type Month struct {
        MonthNumber int
        YearNumber int
    }

    func (m Month) MarshalJSON() ([]byte, error){
        return []byte(fmt.Sprintf("%d/%d", m.MonthNumber, m.YearNumber)), nil
    }

    func (m *Month) UnmarshalJSON(value []byte) error {
        parts := strings.Split(string(value), "/")
        m.MonthNumber = strconv.ParseInt(parts[0], 10, 32)
        m.YearNumber = strconv.ParseInt(parts[1], 10, 32)

        return nil
    }
    ```

#### 2.7.2 将 json 解析成 interface

- `interface{}` 在 Go 中意味着可以是任何东西，Go 在运行时会分配的合适的内存来存储

  ```go
  package main

  import (
    "encoding/json"
    "fmt"
  )

  type myName struct {
    FirstName string `json:"fname"`
    LastName  string `json:"lname"`
  }

  // JSONStruct a struct to be used in json decode
  type myJSONStruct struct {
    myName
    Age    float64 `json:"-"`
    Gender string  `json:",omitempty"`
  }

  var rawJSON = []byte(`{
      "fname": "kiki",
      "lname": "kity",
      "age": 18
  }`)

  func main() {
    var s map[string]interface{}
    err := json.Unmarshal(rawJSON, &s)
    if err != nil {
      panic(err)
    }

    fmt.Printf("[map=%v]", s)
    if s["gender"] == nil {
      panic("Gender is nil")
    }
  }
  ```

#### 2.7.3 使用指针增加代码检查

- 结构体字段使用指针，解析之后判断是否为 nil

  ```go
  package main

  import (
    "encoding/json"
    "fmt"
  )

  // JSONStruct a struct to be used in json decode
  type JSONStruct struct {
    Name *string
    Age  *float64
  }

  var rawJSON = []byte(`{
      "name": "We do not provide a Age"
  }`)

  func main() {
    var s *JSONStruct
    err := json.Unmarshal(rawJSON, &s)
    if err != nil {
      panic(err)
    }

    if s.Name == nil {
      panic("Name is missing or null!")
    }

    if s.Age == nil {
      panic("Age is missing or null!")
    }

    fmt.Printf("Name: %s  Age: %f\n", *s.Name, *s.Age)
  }
  ```

### 3 gin/binding.Bind

- 使用 `binding:"required"` 指定某个域是必须的。当 binding 时该字段为空会返回错误

  ```go
  package main

  import (
    "fmt"
    "time"

    "net/http"

    "github.com/gin-gonic/gin"
  )

  type myJSONStruct struct {
    Name string
    Age  int `binding:"required"`
  }

  func addUser(c *gin.Context) {
    var response interface{}
    data := new(myJSONStruct)
    if err := c.Bind(data); err != nil {
      // [err=Key: 'myJSONStruct.Age' Error:Field validation for 'Age' failed on the 'required' tag]
      fmt.Printf("addUser error [Bind error] [err=%s]\n", err)
      c.JSON(http.StatusBadRequest, response)
      return
    }
    fmt.Printf("addUser success [data=%v]\n", data)
    c.JSON(http.StatusOK, response)
  }

  func main() {
    router := gin.New()
    api := router.Group("/api/adduser")
    api.POST("", addUser)

    httpServer := &http.Server{
      Addr:              "0.0.0.0:10300",
      Handler:           router,
      ReadHeaderTimeout: 5 * time.Second,
    }
    httpServer.ListenAndServe()
  }
  ```

## 4 相关链接

- [Go JSON](https://eager.io/blog/go-and-json/)
- [encoding/json 增加 required 标签被拒绝](https://github.com/golang/go/issues/17163)
- [使用 json.Unmarshal 实现 required 标签](https://stackoverflow.com/questions/19633763/unmarshaling-json-in-golang-required-field)
- [Go 的动态 JSON](https://eagain.net/articles/go-dynamic-json/)
- [gin binding](https://github.com/gin-gonic/gin#model-binding-and-validation)
