setup:
	sudo apt install libgrpc++-dev protobuf-compiler protobuf-compiler-grpc libssl-dev libc-ares-dev

compile-protocol:
	protoc --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` helloworld.proto
	protoc --cpp_out=. helloworld.proto

build-server: compile-protocol
	g++ greeter_server.cc helloworld.grpc.pb.cc helloworld.pb.cc -o greeter_server -std=c++14 `pkg-config --static --libs grpc++` -lgrpc++_reflection

build-client: compile-protocol
	g++ greeter_client.cc helloworld.grpc.pb.cc helloworld.pb.cc -lgrpc++ -lprotobuf -lgrpc -o greeter_client `pkg-config --static --libs grpc++`

build: build-server build-client
