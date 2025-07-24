#!/bin/bash

# Certificate generation script for quantum-safe HTTPS
# Based on the post-quantum hybrid encryption demo

set -e

CERTS_DIR="./certs"
SCRIPTS_DIR="./scripts"

echo "🔐 Generating certificates for quantum-safe HTTPS..."

# Create certificates directory if it doesn't exist
mkdir -p "$CERTS_DIR"

# Generate RSA server certificate and keystore
echo "📋 Generating RSA server certificate..."
keytool -genkeypair \
    -alias server \
    -keyalg RSA \
    -keysize 2048 \
    -sigalg SHA256withRSA \
    -validity 365 \
    -keystore "$CERTS_DIR/server-keystore.p12" \
    -storetype PKCS12 \
    -storepass ballerina \
    -keypass ballerina \
    -dname "CN=server,OU=Engineering,O=Helpers,C=US" \
    -ext "SAN=DNS:localhost,IP:127.0.0.1,IP:0.0.0.0"

# Export server certificate
echo "📤 Exporting server certificate..."
keytool -exportcert \
    -alias server \
    -keystore "$CERTS_DIR/server-keystore.p12" \
    -storetype PKCS12 \
    -storepass ballerina \
    -file "$CERTS_DIR/server-cert.crt"

# Create client truststore and import server certificate
echo "🛡️ Creating client truststore..."
keytool -importcert \
    -alias server \
    -file "$CERTS_DIR/server-cert.crt" \
    -keystore "$CERTS_DIR/client-truststore.p12" \
    -storetype PKCS12 \
    -storepass ballerina \
    -noprompt

# Generate client certificate for mutual TLS
echo "👤 Generating client certificate..."
keytool -genkeypair \
    -alias client \
    -keyalg RSA \
    -keysize 2048 \
    -sigalg SHA256withRSA \
    -validity 365 \
    -keystore "$CERTS_DIR/client-keystore.p12" \
    -storetype PKCS12 \
    -storepass ballerina \
    -keypass ballerina \
    -dname "CN=server,OU=Engineering,O=Helpers,C=US"

# Export client certificate
echo "📤 Exporting client certificate..."
keytool -exportcert \
    -alias client \
    -keystore "$CERTS_DIR/client-keystore.p12" \
    -storetype PKCS12 \
    -storepass ballerina \
    -file "$CERTS_DIR/client-cert.crt"

# Import client certificate to server truststore
echo "🔗 Adding client certificate to server truststore..."
keytool -importcert \
    -alias client \
    -file "$CERTS_DIR/client-cert.crt" \
    -keystore "$CERTS_DIR/server-truststore.p12" \
    -storetype PKCS12 \
    -storepass ballerina \
    -noprompt

# Note: For MLKEM (Kyber) quantum-safe certificates, you would need:
# 1. A custom keystore generation tool (Java-based)
# 2. BouncyCastle provider with post-quantum algorithms
# 3. Hybrid certificate generation combining RSA + MLKEM
echo "⚠️  MLKEM (Quantum-safe) certificate generation requires additional tooling."
echo "    See: https://github.com/hwupathum/ballerina-post-quantum-hybrid-encryption-demo"

echo "✅ Certificate generation completed!"
echo "📁 Certificates are available in: $CERTS_DIR"
echo ""
echo "🔧 Generated files:"
echo "   - $CERTS_DIR/server-keystore.p12 (Server private key & certificate)"
echo "   - $CERTS_DIR/client-truststore.p12 (Client truststore with server cert)"
echo "   - $CERTS_DIR/client-keystore.p12 (Client private key & certificate)"
echo "   - $CERTS_DIR/server-truststore.p12 (Server truststore with client cert)"
echo ""