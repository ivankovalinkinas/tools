namespace My_Local_IP
{
    partial class frmMain
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
            lblCopyRight = new Label();
            btnCopy = new Button();
            txbNetwork = new TextBox();
            SuspendLayout();
            // 
            // lblCopyRight
            // 
            resources.ApplyResources(lblCopyRight, "lblCopyRight");
            lblCopyRight.Name = "lblCopyRight";
            // 
            // btnCopy
            // 
            resources.ApplyResources(btnCopy, "btnCopy");
            btnCopy.Name = "btnCopy";
            btnCopy.UseVisualStyleBackColor = true;
            btnCopy.Click += btnCopy_Click;
            // 
            // txbNetwork
            // 
            resources.ApplyResources(txbNetwork, "txbNetwork");
            txbNetwork.BorderStyle = BorderStyle.FixedSingle;
            txbNetwork.Name = "txbNetwork";
            // 
            // frmMain
            // 
            resources.ApplyResources(this, "$this");
            AutoScaleMode = AutoScaleMode.Font;
            Controls.Add(txbNetwork);
            Controls.Add(btnCopy);
            Controls.Add(lblCopyRight);
            FormBorderStyle = FormBorderStyle.FixedSingle;
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "frmMain";
            TopMost = true;
            Load += frmMain_Load;
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label lblCopyRight;
        private Button btnCopy;
        private TextBox txbNetwork;
    }
}
