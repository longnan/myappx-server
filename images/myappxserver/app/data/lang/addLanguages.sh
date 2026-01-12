#!/usr/bin/env bash

echo "Start Import AD_Language zh_CN Translation..."

echo "*** Adding language zh_CN from folder /opt/appserver/data/lang/zh_CN_System *** - $(date +'%Y-%m-%d %H:%M:%S')"
cd $IDEMPIERE_HOME/utils
bash RUN_TrlImport.sh zh_CN /opt/appserver/data/lang/zh_CN_System

echo "*** Synchronize Terminology *** - $(date +'%Y-%m-%d %H:%M:%S')"
cd $IDEMPIERE_HOME/utils
bash RUN_SyncTerm.sh

echo "AD_Language zh_CN Translation Imported!"
