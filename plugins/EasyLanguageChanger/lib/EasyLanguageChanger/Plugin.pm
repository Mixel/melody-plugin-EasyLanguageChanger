package EasyLanguageChanger::Plugin;
use strict;
use Data::Dumper;
my $salida = '';

sub loadLanguages {
  my ($eh, $app, $tmpl) = @_;

  my $langs = $app->languages_list();
  my $aux = '';
 
  my $params = $app->query_string();
  $params =~ s/;/&/ig;

  if($app->query->param('__lang')){
    $params =~ s/&?__lang=\w+-?\w+//i
  }
 
  $params .= ($params)?'&__lang=':'__lang=';
  my $path = $app->app_uri() .'?' ;
  $path .= $params;
  
  for my $lang ( @$langs) {  
     $aux .= '<li><a href="' .$path . $lang->{l_tag} .'">' . $lang->{l_name} .'</a></li>';
  }
  
  $salida =~ s/__LANGS__/$aux/mi;
  $aux = $app->config('StaticWebPath');
  $salida =~ s/__STATIC__/$aux/mi;
  my $title = $app->translate('Change language');
  $salida =~ s/__TITLE__/$title/mi;
  
  $$tmpl =~ s/<mt:if name="blog_id">\s*<mt:if name="can_create_post">/$salida/mi;
   return 1;
}

sub _debug  {
  my ($texto) = @_;
  MT->log({message => $texto});
}


$salida = '
  <li id="language-selector-control" class="nav-menu has-sub-nav">  
     <a href="#" mt:command="open-menu"  id="language-control"><em>__TITLE__</em>  <span> </span></a>  
      <ul class="subnav">
         __LANGS__
      </ul>
  </li>
<style>
 #language-control{
    background:#FFFFFF url(__STATIC__/images/blog-selector-control.gif) repeat-x scroll left bottom;
    font-size:14px;
    margin-left:1px;
    overflow:hidden;
    padding:6px 10px 5px !important;
}
</style>
  <mt:if name="blog_id">
 <mt:if name="can_create_post">
';


1;
