% akizumi-hw.cls -- homework.
%   \documentclass[lang=zh, solutions=false]{akizumi-hw}
%   \akizumisetup{course=ODE, number=3, due=2026/10/28, id=B12345678}
%   \begin{problem}[optional title] ... \begin{solution} ... \end{solution} \end{problem}
%   problem numbering, \inputproblem, parts, kind=: see akizumi-problems.sty; header=, footer=: akizumi-pagestyle.sty
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{akizumi-hw}[2026/10/26 v0.9 Aaron Lin homework]

\newif\ifakizumi@solutions \akizumi@solutionstrue
\ExplSyntaxOn
\tl_new:N \l__akizumi_size_tl
\tl_set:Nn \l__akizumi_size_tl { 11pt }
\keys_define:nn { akizumi/hw }
  {
    lang      .code:n = \PassOptionsToPackage { lang = #1 } { akizumi-core },
    thmnames  .code:n = \PassOptionsToPackage { thmnames = #1 } { akizumi-core },
    cjk       .code:n = \PassOptionsToPackage { cjk = #1 } { akizumi-core },
    bb        .code:n = \PassOptionsToPackage { bb = #1 } { akizumi-core },
    text      .code:n = \PassOptionsToPackage { text = #1 } { akizumi-core },
    bib       .code:n = \PassOptionsToPackage { bib = {#1} } { akizumi-core },
    paper     .code:n = \PassOptionsToPackage { paper = #1 } { akizumi-core },
    layout    .code:n = \PassOptionsToPackage { layout = #1 } { akizumi-core },
    byline    .code:n = \PassOptionsToPackage { byline = #1 } { akizumi-core },
    byline    .default:n = true,
    solutions .choices:nn = { true, false }
      { \use:c { akizumi@solutions \l_keys_choice_tl } },
    solutions .default:n = true,
    kind         .code:n = \PassOptionsToPackage { kind = #1 } { akizumi-problems },
    header       .code:n = \PassOptionsToPackage { header = #1 } { akizumi-pagestyle },
    problembreak .code:n = \PassOptionsToPackage { problembreak = #1 } { akizumi-problems },
    problembreak .default:n = true,
    10pt      .code:n = \tl_set:Nn \l__akizumi_size_tl { 10pt },
    11pt      .code:n = \tl_set:Nn \l__akizumi_size_tl { 11pt },
    12pt      .code:n = \tl_set:Nn \l__akizumi_size_tl { 12pt },
    unknown   .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { article } },
  }
\ProcessKeyOptions [ akizumi/hw ]
% Override from the command line (see akizumi-both): \def\akizumisolutions{true|false}
\cs_if_exist:NT \akizumisolutions { \use:c { akizumi@solutions \akizumisolutions } }
\use:x { \exp_not:N \LoadClass [ a4paper, \l__akizumi_size_tl ] { article } }
\ExplSyntaxOff

\RequirePackage{akizumi-core}
\akizumi@setgeometry{margin=2.5cm, top=2.3cm, headsep=0.8cm, headheight=15pt}

% ---------- title: "Homework 3"; course, author, ID and due date in the details row ----------
\title{\akizumi@str{hwkind-\akizumi@kind}\ifx\akizumi@number\@empty\else\ \akizumi@number\fi}
\newcommand{\akizumi@duename}{\akizumi@str{due}}
\renewcommand{\akizumi@headleft}{\akizumi@course\ifx\akizumi@course\@empty\else\quad\fi\@title}

% ---------- problems, parts, kind= ----------
\RequirePackage{akizumi-problems}

% ---------- solutions: thin left rule; hidden with solutions=false ----------
% The body is not read as an argument, so it may hold verbatim and codeblock;
% hidden, it is skipped line by line (akizumi-exercise's reader). The reader
% must be the last token of \begin{solution}.
\RequirePackage{verbatim}
\newenvironment{solution}
  {\ifakizumi@solutions
     \let\akizumi@sol@next\akizumi@solinline\let\endsolution\endakizumi@solinline
   \else
     \@bsphack\let\akizumi@sol@next\akizumi@sol@hidestart\let\endsolution\@esphack
   \fi
   \akizumi@sol@next}
  {}

\endinput
