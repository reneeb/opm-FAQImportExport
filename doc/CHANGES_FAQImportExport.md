# Change log of FAQImportExport
* Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de/
* Maintenance 2018 - Perl-Services.de, http://perl-services.de
* $Id: CHANGES_FAQImportExport.md,v 1.8 2015/11/17 12:54:52 tlange Exp $

* ROADMAP TASKS
* (????/??/??)  - CR:T                  (export/import attachments into/from file)
* (????/??/??)  - CR:T                  (update existing category in FAQ.pm (ID and full name given))

#6.0.0 (2018/02/02)
 * (2018/02/02) - ported to OTRS6 (reneeb)

#5.0.0 (2015/11/17)
 * (2015/09/07) - CR: T2015082690000544 (added changes for OTRS 5.0.x) (tlange)

#4.0.0 (2015/07/23)
 * (2015/07/23) - CR: T2015072390000435 (added changes for OTRS 4.0.x - no dynamic field support!) (tto)

#1.3.0 (2013/11/14)
 * (2013/10/21) - CR: T2013101490000851 (added changes for OTRS 3.3.x) (smehlig)

#1.2.0 (2013/02/19)
 * (2013/02/19) - CR: T2013021290000138 (added Sysconfig option for auotm. CSV-mapping creation on reinstall/upgrade) (alitvinova)
 * (2013/02/19) - CR: T2013021290000138 (modifications for ITSM3.1.7 and framework OTRS 3.2.x) (alitvinova)
 * (2013/02/19) - CR: T2013021290000138 (modifications for FAQ 2.2.x) (alitvinova)

#1.1.1 (2013/01/15)
 * (2013/01/15) - CR: added removing of <xml>*</xml> and <style>*</style> on plain text export (millinger)

#1.1.0 (2012/04/13)
 * (2012/03/09) - Bugfix: (exported FAQs should be sorted by IDs ascendant to avoid import problems) (alitvinova)
 * (2012/03/08) - CR: T2012022790000237 (modifications for OTRS 3.1.x) (alitvinova)
 * (2012/03/08) - CR: T2012022790000237 (add new FAQs if "Number" is not configured as identifier) (alitvinova)
 * (2012/03/08) - CR: T2012022790000237 (deleted "Export with labels" attribute) (alitvinova)
 * (2012/03/08) - CR: T2012022790000237 (removed html-version of pod documentation) (alitvinova)
 * (2011/04/19) - CR: added limit for FAQ-item export
 * (2011/03/20) - CR: moved usage information to pod-file in <OTRS_HOME>/doc/en

#1.0.0 (2011/03/08)
 * (2011/03/08) - CR: file USAGE_faqimportexport for documentation purpose.
 * (2011/02/24) - Bugfix: completed automatic import-/export mapping creation.
 * (2011/02/21) - CR: readable Approved-State im-/export
 * (2011/02/20) - CR: added import-parameters and improved im-/export of categories

#0.6.0 (2011/02/16)
 * (2011/02/16) - CR: changes for use with OTRS 3.0.x

#0.5.0 (2010/10/01)
 * (2010/10/01) - CR: First pre-productive release of general faq import-/export backend.
