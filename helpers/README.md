# Helpers API

A secure HTTP service built with Ballerina that provides utility endpoints inspired by httpbin.org, featuring quantum-safe HTTPS encryption and AI-powered text processing.

## 🚀 Features

- **Echo Services**: Get client IP, user-agent headers
- **Data Generation**: UUID v4 generation  
- **Data Conversion**: Base64 encoding/decoding
- **AI Processing**: Grammar and spelling correction via OpenAI
- **Quantum-Safe HTTPS**: TLS 1.3 with strong cipher suites
- **Security**: Mutual TLS authentication, HTTP to HTTPS redirects

## 🔧 Quick Start

### Prerequisites

- [Ballerina](https://ballerina.io/) (Swan Lake Update 12+)
- JDK 11+
- OpenAI API key

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd helpers
   ```

2. **Generate SSL certificates**
   ```bash
   ./scripts/generate-certs.sh
   ```

3. **Configure secrets** in `Config.toml`:
   ```toml
   OPENAI_KEY="your-openai-api-key"
   keyStorePassword="your-keystore-password"
   mlkemKeyStorePassword="your-mlkem-password"
   ```

4. **Run the service**
   ```bash
   bal run
   ```

The service will start with:
- HTTPS on port 8443 (main service)
- HTTP on port 8080 (redirects to HTTPS)

## 📡 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/ip` | GET | Returns client IP address |
| `/user-agent` | GET | Returns user-agent header |
| `/uuid` | GET | Generates UUID v4 |
| `/base64/encode/{value}` | POST | Base64 encodes string |
| `/base64/decode/{value}` | POST | Base64 decodes string |
| `/ai/spelling` | POST | AI grammar/spelling correction |

### Example Usage

```bash
# Get your IP address
curl -k https://localhost:8443/ip

# Generate UUID
curl -k https://localhost:8443/uuid

# Base64 encode
curl -k -X POST https://localhost:8443/base64/encode/hello

# AI spelling correction
curl -k -X POST https://localhost:8443/ai/spelling \
  -H "Content-Type: application/json" \
  -d '{"text": "This is a sentance with errrors"}'
```

## 🔐 Security Features

- **TLS 1.3**: Modern encryption protocols only
- **Quantum-Safe Ready**: Configured for hybrid RSA/QBC algorithms
- **Strong Ciphers**: AES-256-GCM, ChaCha20-Poly1305, ECDHE suites
- **Mutual TLS**: Client certificate verification
- **Auto HTTPS**: HTTP requests automatically redirect to HTTPS
- **Input Validation**: Regex patterns and length constraints

## ⚙️ Configuration

The service supports these configurable parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `host` | `"0.0.0.0"` | Listen on all interfaces |
| `port` | `8443` | HTTPS port |
| `httpPort` | `8080` | HTTP redirect port |
| `aiModel` | `"gpt-4o-mini"` | OpenAI model |
| `keyStorePath` | `"./certs/server-keystore.p12"` | SSL keystore location |

Override defaults in `Config.toml` or via environment variables.

## 🏗️ Development

### Build Commands

```bash
# Build project
bal build

# Update dependencies  
bal deps pull

# Generate certificates
./scripts/generate-certs.sh
```

You can also generate manually a certificate using certbot (Let's Encrypt) as follows:

```bash
certbot certonly   --manual   --preferred-challenges dns   --key-type rsa   --rsa-key-size 4096   -d <DNS_name>

```

### Project Structure

```
helpers/
├── helpers-spec_service.bal    # Main HTTP service
├── types.bal                   # Type definitions
├── helpers-spec.yaml          # OpenAPI specification  
├── Config.toml                # Secret configuration
├── scripts/
│   └── generate-certs.sh      # Certificate generation
└── certs/                     # SSL certificates
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Related

- [Ballerina Language](https://ballerina.io/)
- [Post-Quantum Cryptography](https://github.com/hwupathum/ballerina-post-quantum-hybrid-encryption-demo)
- [httpbin.org](https://httpbin.org/) - Inspiration for utility endpoints