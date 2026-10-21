% aaron-note.cls -- lecture notes, handouts, write-ups.
%   \documentclass[lang=zh]{aaron-note}
%   \aaronsetup{course=ODE, kicker={ODE · Lecture 3}}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aaron-note}[2026/10/21 v0.4 Aaron Lin notes]

\ExplSyntaxOn
\tl_new:N \l__aaron_size_tl
\tl_set:Nn \l__aaron_size_tl { 11pt }
\keys_define:nn { aaron/note }
  {
    lang    .code:n = \PassOptionsToPackage { lang = #1 } { aaron-core },
    cjk     .code:n = \PassOptionsToPackage { cjk = #1 } { aaron-core },
    bb      .code:n = \PassOptionsToPackage { bb = #1 } { aaron-core },
    text    .code:n = \PassOptionsToPackage { text = #1 } { aaron-core },
    bib     .code:n = \PassOptionsToPackage { bib = {#1} } { aaron-core },
    paper   .code:n = \PassOptionsToPackage { paper = #1 } { aaron-core },
    layout  .code:n = \PassOptionsToPackage { layout = #1 } { aaron-core },
    10pt    .code:n = \tl_set:Nn \l__aaron_size_tl { 10pt },
    11pt    .code:n = \tl_set:Nn \l__aaron_size_tl { 11pt },
    12pt    .code:n = \tl_set:Nn \l__aaron_size_tl { 12pt },
    unknown .code:n = \use:x { \exp_not:N \PassOptionsToClass { \l_keys_key_str } { article } },
  }
\ProcessKeyOptions [ aaron/note ]
\use:x { \exp_not:N \LoadClass [ a4paper, \l__aaron_size_tl ] { article } }
\ExplSyntaxOff

\RequirePackage{aaron-core}
\aaron@setgeometry{margin=2.7cm, headsep=0.8cm, headheight=15pt}

% Kicker above the title defaults to the course name.
\AtBeginDocument{\ifx\aaron@kicker\@empty\let\aaron@kicker\aaron@course\fi}
\renewcommand{\aaron@headleft}{\ifx\aaron@course\@empty\@title\else\aaron@course\fi}

% Theorems and equations numbered within sections in notes.
\aaron@thmwithin{section}
\counterwithin{equation}{section}

% Running header: course (or title) left, current section right.
\renewcommand{\sectionmark}[1]{\markboth{\ifnum\c@secnumdepth>\z@\thesection\quad\fi#1}{}}
\renewcommand{\aaron@headright}{\leftmark}

\endinput
