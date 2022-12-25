setup:
	sudo apt install libgrpc++-dev protobuf-compiler-grpc

compile-protocol:
	protoc --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` helloworld.proto
	protoc --cpp_out=. helloworld.proto

build-server: compile-protocol
	g++ greeter_server.cc helloworld.grpc.pb.cc helloworld.pb.cc -o greeter_server \
		`pkg-config --libs grpc++ protobuf` -lgrpc++_reflection

build-client: compile-protocol
	g++ greeter_client.cc helloworld.grpc.pb.cc helloworld.pb.cc -o greeter_client \
		`pkg-config --libs grpc++ protobuf`

build: build-server build-client

run:
	./greeter_server &
	sleep 1
	./greeter_client
