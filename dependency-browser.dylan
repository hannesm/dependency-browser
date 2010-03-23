module: dependency-browser

define constant $commands = make(<table>);

define macro command-definer
  {
   define command ?:name (?args:*)
     ?:body
   end
} => {
      $commands[?#"name"] := method(?args) => (result) ?body end;
 }
end;

define command projects ()
  let res = #();
  local method collect-project
            (dir :: <pathname>, filename :: <string>, type :: <file-type>)
          if (type == #"file" & filename ~= "Open-Source-License.txt")
            if (last(filename) ~= '~')
	      let p = as(<symbol>, filename);
	      unless (member?(p, res))
		res := pair(p, res);
	      end;
            end;
          end;
        end;
  let regs = find-registries($machine-name, $os-name);
  let reg-paths = map(registry-location, regs);
  for (reg-path in reg-paths)
    if (file-exists?(reg-path))
      do-directory(collect-project, reg-path);
    end;
  end;
  list(#"new-nodes", res)
end;

define command title ()
  list(#"title", concatenate(application-name(), " on ", as(<string>, $machine-name), "-", as(<string>, $os-name)))
end;

define command edges (project)
  block()
    let p = find-project(as(<string>, project));
    unless (open-project-compiler-database(p))
      parse-project-source(p)
    end;
    let used = project-used-projects(p);
    list(#"new-edges", project, map(compose(curry(as, <symbol>), project-name), used))
  exception (c :: <condition>)
    //format(*standard-error*, "couldn't parse project %= %=\n", project, c);
    list(#"new-edges", project, #())
  end;
end;

define function main()
  format-out("Hello, world!\n");
  force-output(*standard-output*);
  connect-java();
  while (#t)
    let req = read-java();
    let c = req.first;
    if (element($commands, c, default: #f))
      write-java(apply($commands[req.first], req.tail));
    else
      format(*standard-error*, "didn't understood %=\n", req);
      write-java(#"fail");
    end
  end;
  exit-application(0);
end function main;

// Invoke our main() function.
main();
