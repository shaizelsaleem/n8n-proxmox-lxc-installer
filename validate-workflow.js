#!/usr/bin/env node

// Workflow Validation Script
// Validates the n8n workflow JSON file for syntax and required nodes

const fs = require('fs');
const path = require('path');

console.log('🔍 Validating News Bulletin Workflow...');

const workflowFile = path.join(__dirname, 'news-bulletin-workflow.json');

try {
    // Check if workflow file exists
    if (!fs.existsSync(workflowFile)) {
        console.error('❌ Workflow file not found:', workflowFile);
        process.exit(1);
    }

    // Read and parse workflow
    const workflowContent = fs.readFileSync(workflowFile, 'utf8');
    const workflow = JSON.parse(workflowContent);

    console.log('✅ Workflow JSON is valid');

    // Validate required nodes
    const requiredNodes = [
        'Schedule Trigger',
        'Fetch XML News Files',
        'Parse File Paths',
        'Read XML Content',
        'Parse XML News',
        'Find Supporting Media',
        'Combine News with Media',
        'Generate Script (Ollama)',
        'Parse Script Response',
        'Generate Audio (ElevenLabs)',
        'Prepare Workspace',
        'Generate Video (ComfyUI)',
        'Prepare Assembly Data',
        'Assemble Final Bulletin',
        'Final Cleanup',
        'Success Notification'
    ];

    const workflowNodes = workflow.nodes.map(node => node.name);
    const missingNodes = requiredNodes.filter(node => !workflowNodes.includes(node));

    if (missingNodes.length > 0) {
        console.error('❌ Missing required nodes:');
        missingNodes.forEach(node => console.error('   -', node));
        process.exit(1);
    }

    console.log('✅ All required nodes are present');

    // Validate node connections
    const connections = workflow.connections;
    let connectionErrors = [];

    // Check if trigger node has output connection
    if (!connections['Schedule Trigger'] || !connections['Schedule Trigger'].main[0][0]) {
        connectionErrors.push('Schedule Trigger not connected to next node');
    }

    // Check final connection
    const lastNode = 'Success Notification';
    if (!connections['Final Cleanup'] || !connections['Final Cleanup'].main[0][0]) {
        connectionErrors.push('Final Cleanup not connected to Success Notification');
    }

    if (connectionErrors.length > 0) {
        console.error('❌ Connection errors:');
        connectionErrors.forEach(error => console.error('   -', error));
        process.exit(1);
    }

    console.log('✅ Node connections are valid');

    // Validate API endpoints
    const apiEndpoints = {
        'Generate Script (Ollama)': 'http://localhost:11434/api/generate',
        'Generate Video (ComfyUI)': 'http://localhost:8188/prompt'
    };

    for (const [nodeName, expectedUrl] of Object.entries(apiEndpoints)) {
        const node = workflow.nodes.find(n => n.name === nodeName);
        if (node && node.parameters.url !== expectedUrl) {
            console.warn(`⚠️  ${nodeName} URL mismatch: expected ${expectedUrl}, got ${node.parameters.url}`);
        }
    }

    // Validate environment variable references
    const envVarPattern = /\{\{\s*\$vars\.(\w+)\s*\}\}/g;
    let envVarMatches = [];
    let match;

    workflowContent.replace(envVarPattern, (fullMatch, varName) => {
        envVarMatches.push(varName);
        return fullMatch;
    });

    const requiredEnvVars = ['ELEVENLABS_API_KEY', 'ELEVENLABS_VOICE_ID'];
    const missingEnvVars = requiredEnvVars.filter(varName => !envVarMatches.includes(varName));

    if (missingEnvVars.length > 0) {
        console.warn('⚠️  Missing environment variable references:');
        missingEnvVars.forEach(varName => console.warn('   -', varName));
    }

    // Check for hardcoded credentials
    const credentialPattern = /(api[_-]?key|password|token)["\s]*[:=]["\s]*["\']([^"\']+)["\']/i;
    if (credentialPattern.test(workflowContent)) {
        console.warn('⚠️  Potential hardcoded credentials detected in workflow');
    }

    // Validate file paths
    const filePathPattern = /\/home\/engine\/project\/[a-zA-Z0-9_\/\-\.]+/g;
    const filePaths = workflowContent.match(filePathPattern) || [];

    const invalidPaths = filePaths.filter(path => {
        return !path.startsWith('/home/engine/project/');
    });

    if (invalidPaths.length > 0) {
        console.warn('⚠️  Potentially invalid file paths:');
        invalidPaths.forEach(path => console.warn('   -', path));
    }

    console.log('✅ File paths appear valid');

    // Check workflow complexity
    const nodeCount = workflow.nodes.length;
    const connectionCount = Object.keys(connections).length;

    console.log(`📊 Workflow Statistics:`);
    console.log(`   Nodes: ${nodeCount}`);
    console.log(`   Connections: ${connectionCount}`);
    console.log(`   Environment variables: ${envVarMatches.length}`);

    if (nodeCount > 50) {
        console.warn('⚠️  Workflow has many nodes, consider simplifying');
    }

    console.log('🎉 Workflow validation completed successfully!');

} catch (error) {
    console.error('❌ Validation failed:', error.message);
    process.exit(1);
}