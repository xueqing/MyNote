# perl 脚本解析 xml 文件

- 1 使用模块 XML::Simple。XML::Simple 能够解析一个 XML 文件并在以一个 Perl 哈希引用返回数据。在这个哈希中，来自原始 XML 文件的元素作为键，而它们之间的 CDATA 作为值。一旦XML::Simple 处理完一个 XML 文件，XML 文件的内容就可以使用标准 Perl 数组表示法检索。
- 2 安装步骤，进入命令行执行：
  - 1 `perl -MCPAN -e shell`
  - 2 `install XML::Simple`
- 3 脚本内容

  ```perl
  #!/usr/bin/perl
  
  # use module
  use XML::Simple;
  
  if($#ARGV < 1) {
    print "Usage: ./parsexml.pl filename parseparam\n";
    exit(0);
  }
  
  $filename = $ARGV[0];
  $parseparam = $ARGV[1];
  #print "Input param [filename=$filename] [parseparam=$parseparam]\n";
  
  # create object
  $xml = new XML::Simple;
  
  # read XML file
  my $doc = $xml->XMLin($filename);
  
  # access XML data
  print "$doc->{$parseparam}\n";
  ```

- 4 执行脚本
  - 1 添加可执行权限：`chmod +x parsexml.pl`
  - 2 执行：`./parsexml.pl filename parseparam`