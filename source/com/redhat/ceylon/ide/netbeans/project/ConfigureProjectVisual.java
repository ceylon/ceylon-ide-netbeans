package com.redhat.ceylon.ide.netbeans.project;

import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.JTextField;
import org.openide.filesystems.FileChooserBuilder;

/**
 *
 * @author bastien
 */
public class ConfigureProjectVisual extends javax.swing.JPanel {

    /**
     * Creates new form ConfigureProjectVisual
     */
    public ConfigureProjectVisual() {
        initComponents();
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel2 = new javax.swing.JLabel();
        projectName = new javax.swing.JTextField();
        jPanel1 = new javax.swing.JPanel();
        compileJvm = new javax.swing.JCheckBox();
        compileJs = new javax.swing.JCheckBox();
        workOffline = new javax.swing.JCheckBox();
        showWarning = new javax.swing.JCheckBox();
        jLabel1 = new javax.swing.JLabel();
        projectLocation = new javax.swing.JTextField();
        jButton1 = new javax.swing.JButton();

        org.openide.awt.Mnemonics.setLocalizedText(jLabel2, "Project name:");

        projectName.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                projectNameActionPerformed(evt);
            }
        });

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("Target virtual machine"));

        org.openide.awt.Mnemonics.setLocalizedText(compileJvm, "Compile project for JVM");
        compileJvm.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                compileJvmActionPerformed(evt);
            }
        });

        org.openide.awt.Mnemonics.setLocalizedText(compileJs, "Compile project to JavaScript");
        compileJs.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                compileJsActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(compileJvm)
                    .addComponent(compileJs))
                .addContainerGap(263, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(compileJvm)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(compileJs))
        );

        org.openide.awt.Mnemonics.setLocalizedText(workOffline, "Work offline (disable connection to remote module repositories)");

        org.openide.awt.Mnemonics.setLocalizedText(showWarning, "Show compilation warnings");

        org.openide.awt.Mnemonics.setLocalizedText(jLabel1, "Location:");

        org.openide.awt.Mnemonics.setLocalizedText(jButton1, "Browse...");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap())
                    .addComponent(workOffline)
                    .addComponent(showWarning)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 95, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel1))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(projectName)
                            .addComponent(projectLocation, javax.swing.GroupLayout.DEFAULT_SIZE, 294, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1))))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(projectName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(projectLocation, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(workOffline)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(showWarning)
                .addContainerGap(84, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void projectNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_projectNameActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_projectNameActionPerformed

    private void compileJvmActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_compileJvmActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_compileJvmActionPerformed

    private void compileJsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_compileJsActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_compileJsActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        FileChooserBuilder builder = new FileChooserBuilder(ConfigureProjectVisual.class);
        builder.setDirectoriesOnly(true);
        
        JFileChooser chooser = builder.createFileChooser();
        if (chooser.showOpenDialog(jPanel1) == JFileChooser.APPROVE_OPTION) {
            File f = chooser.getSelectedFile();
            
            projectLocation.setText(f.getAbsolutePath());
        }
    }//GEN-LAST:event_jButton1ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JCheckBox compileJs;
    private javax.swing.JCheckBox compileJvm;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JTextField projectLocation;
    private javax.swing.JTextField projectName;
    private javax.swing.JCheckBox showWarning;
    private javax.swing.JCheckBox workOffline;
    // End of variables declaration//GEN-END:variables

    public JTextField getProjectLocation() {
        return projectLocation;
    }

    public JTextField getProjectName() {
        return projectName;
    }
}
