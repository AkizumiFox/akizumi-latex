% akizumi-note.cls -- lecture notes, handouts, write-ups.
%   \documentclass[lang=zh]{akizumi-note}
%   \akizumisetup{course=ODE, kicker={ODE · Lecture 3}}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{akizumi-note}[2026/10/21 v0.7 Aaron Lin notes]

\ExplSyntaxOn
\tl_new:N \l__akizumi_size_tl
\tl_set:Nn \l__akizumi_size_tl { 11pt }
\keys_define:nn { akizumi/note }
  {
    lang    .code:n = \PassOptionsToPackage { lang = #1 } { akizumi-core },
    cjk     .code:n = \PassOptionsToPackage { cjk = #1 } { akizumi-core },
    bb      .code:n = \PassOptionsToPackage { bb = #1 } { akizumi-core },
    text    .code:n = \PassOptionsToPackage { text = #1 } { akizumi-core },
    bib     .code:n = \PassOptionsToPackage { bib = {#1} } { akizumi-core },
    paper   .code:n = \PassOptionsToPackage { paper = #1 } { akizumi-core },
    layout  .code:n = \PassOptionsToPackage { layout = #1 } { akizumi-core },
    10pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 10pt },
    11pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 11pt },
    12pt    .code:n = \tl_set:Nn \l__akizumi_size_tl { 12pt },
    unknown .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { article } },
  }
\ProcessKeyOptions [ akizumi/note ]
\use:x { \exp_not:N \LoadClass [ a4paper, \l__akizumi_size_tl ] { article } }
\ExplSyntaxOff

\RequirePackage{akizumi-core}
\akizumi@setgeometry{margin=2.7cm, headsep=0.8cm, headheight=15pt}

% Kicker above the title defaults to the course name.
\AtBeginDocument{\ifx\akizumi@kicker\@empty\let\akizumi@kicker\akizumi@course\fi}
\renewcommand{\akizumi@headleft}{\ifx\akizumi@course\@empty\@title\else\akizumi@course\fi}

% Theorems and equations numbered within sections in notes.
\akizumi@thmwithin{section}
\counterwithin{equation}{section}

% Running header: course (or title) left, current section right.
\renewcommand{\sectionmark}[1]{\markboth{\ifnum\c@secnumdepth>\z@\thesection\quad\fi#1}{}}
\renewcommand{\akizumi@headright}{\leftmark}

\endinput
