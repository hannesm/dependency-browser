module: dependency-browser

define variable *sock* :: false-or(<socket>) = #f;

define function write-java (data) => (answer)
  let ss = make(<string-stream>, direction: #"output");
  print-s-expression(ss, data);
  let ss-data = ss.stream-contents;
  format(*sock*, "%s%s", integer-to-string(ss-data.size, base: 16, size: 6), ss-data);
end;

define function read-java () => (s)
  let l = string-to-integer(read(*sock*, 6), base: 16);
  let a = read-lisp(make(<string-stream>, direction: #"input", contents: read(*sock*, l)));
  format(*standard-output*, "%=", a);
  force-output(*standard-output*);
  a
end;

define function connect-java () => (answer)
  block()
    *sock* := make(<tcp-socket>, host: "127.0.0.1", port: 1234);
  exception (c :: <socket-condition>)
    format(*standard-error*, "socket condition while setup %=\n", c);
  end;
end;
