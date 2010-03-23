module: dylan-user

define library dependency-browser
  use common-dylan;
  use io;
  use lisp-reader;
  use network;
  use system;
  use registry-projects;
  use projects;
  use environment-protocols;
  use dfmc-environment-projects;
end library;

define module dependency-browser
  use common-dylan;
  use format-out;
  use streams;
  use standard-io;
  use lisp-reader;
  use sockets, import: { <tcp-socket>, <socket>, <socket-condition> };
  use format, import: { format };
  use file-system, import: { <pathname>, do-directory, <file-type>, file-exists? };
  use operating-system, import: { $os-name, $machine-name };
  use registry-projects, import: { find-registries, registry-location };
  use projects;
  use environment-protocols;
  use dfmc-environment-projects;
end module;
