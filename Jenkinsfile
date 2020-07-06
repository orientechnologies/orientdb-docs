@Library(['piper-lib', 'piper-lib-os']) _   

node {

    stage('build')   {
                    
        sh "rm -rf *"
        
        executeDocker(
        dockerImage:'ldellaquila/gitbook:latest',
          dockerWorkspace: '/home/jenkins/workspace/orientdb-docs-${env.BRANCH_NAME}'        
          ) {
	   try{
              
              checkout(
                    [$class: 'GitSCM', branches: [[name: "${env.BRANCH_NAME}"]], 
                    doGenerateSubmoduleConfigurations: false, 
                    extensions: [], 
                    submoduleCfg: [], 
                    extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'orientdb-docs']],
                    userRemoteConfigs: [[url: 'https://github.com/orientechnologies/orientdb-docs']]])
              
              
		    sh '''
		        cd orientdb-docs
		        rm -rf _/book/*
		        gitbook install --gitbook 3.1.1 .
		        gitbook build --gitbook 3.1.1 .
		        gitbook pdf --gitbook 3.1.1 . _book/OrientDB-Manual.pdf
		    '''
		    
	//      withCredentials([usernamePassword(credentialsId: 'orientdb_website', passwordVariable: 'RSYNC_PASSWORD', usernameVariable: 'RSYNC_USERNAME')]) {
        //          sh '''
        //       	      rsync -ratlz --stats --rsh="/usr/bin/sshpass -p ${RSYNC_PASSWORD} ssh -o StrictHostKeyChecking=no -l ${RSYNC_USERNAME}" orientdb-docs/_book/ orientdb.com:/home/orientdb/public_html/docs/3.0.x  
        //             '''
        //      }
		   
	      withCredentials([usernamePassword(credentialsId: 'orientdb_org_website', passwordVariable: 'RSYNC_PASSWORD', usernameVariable: 'RSYNC_USERNAME')]) {
                  sh '''
               	      rsync -ratlz --stats --rsh="/usr/bin/sshpass -p ${RSYNC_PASSWORD} ssh -o StrictHostKeyChecking=no -l ${RSYNC_USERNAME}" orientdb-docs/_book/ orientdb.org:/home/orientdb/orientdb.org/docs/3.0.x  
                     '''
              }

	} catch(e) {
		slackSend(color: '#FF0000', channel: '#jenkins-failures', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})\n${e}")
		throw e
	   }
	   slackSend(color: '#00FF00', channel: '#jenkins', message: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
        
    }
    
}
