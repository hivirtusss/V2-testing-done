package com.virtus.gl.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.virtus.gl.R;
import com.virtus.gl.auth.AuthResult;
import com.virtus.gl.auth.VirtusAuthClient;
import com.virtus.gl.util.DeviceUtils;
import com.virtus.gl.util.SessionStore;

public class LoginActivity extends AppCompatActivity {
    private EditText userEdit;
    private EditText pwdEdit;
    private Button loginBtn;
    private SessionStore session;
    private VirtusAuthClient auth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        session = new SessionStore(this);
        auth = new VirtusAuthClient();

        userEdit = findViewById(R.id.userEdit);
        pwdEdit = findViewById(R.id.pwdEdit);
        loginBtn = findViewById(R.id.loginBtn);

        userEdit.setText(session.getUsername());
        pwdEdit.setText(session.getPassword());

        findViewById(R.id.enrollBtn).setOnClickListener(v -> showRegisterDialog());
        findViewById(R.id.rechargeBtn).setOnClickListener(v -> showRechargeDialog());
        findViewById(R.id.serverLineBtn).setOnClickListener(v -> showServerLineDialog());
        findViewById(R.id.togglePwd).setOnClickListener(v -> togglePassword());

        loginBtn.setOnClickListener(v -> doLogin());
    }

    private void togglePassword() {
        int type = pwdEdit.getInputType();
        if ((type & InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD) != 0) {
            pwdEdit.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
        } else {
            pwdEdit.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
        }
        pwdEdit.setSelection(pwdEdit.getText().length());
    }

    private void doLogin() {
        String user = userEdit.getText().toString().trim();
        String pass = pwdEdit.getText().toString().trim();
        if (user.isEmpty() || pass.isEmpty()) {
            toast(R.string.account_password_empty);
            return;
        }
        loginBtn.setEnabled(false);
        new Thread(() -> {
            AuthResult result = auth.login(user, pass, DeviceUtils.getDeviceId());
            runOnUiThread(() -> {
                loginBtn.setEnabled(true);
                if (result.success) {
                    session.saveCredentials(user, pass);
                    session.saveProfile(result.profile);
                    startActivity(new Intent(this, DashboardActivity.class));
                    finish();
                } else {
                    toast(result.message);
                }
            });
        }).start();
    }

    private void showRegisterDialog() {
        View view = getLayoutInflater().inflate(R.layout.dialog_register, null);
        EditText user = view.findViewById(R.id.dialogUser);
        EditText pass = view.findViewById(R.id.dialogPass);
        new AlertDialog.Builder(this)
                .setTitle(R.string.enroll)
                .setView(view)
                .setPositiveButton(R.string.ok, (d, w) -> {
                    String u = user.getText().toString().trim();
                    String p = pass.getText().toString().trim();
                    if (u.isEmpty() || p.isEmpty()) {
                        toast(R.string.account_password_empty);
                        return;
                    }
                    new Thread(() -> {
                        AuthResult result = auth.register(u, p, DeviceUtils.getDeviceId());
                        runOnUiThread(() -> toast(result.success
                                ? R.string.enrollment_success
                                : result.message));
                    }).start();
                })
                .setNegativeButton(R.string.cancel, null)
                .show();
    }

    private void showRechargeDialog() {
        View view = getLayoutInflater().inflate(R.layout.dialog_recharge, null);
        EditText user = view.findViewById(R.id.dialogUser);
        EditText key = view.findViewById(R.id.dialogKey);
        user.setText(userEdit.getText().toString().trim());
        new AlertDialog.Builder(this)
                .setTitle(R.string.activation_renewal)
                .setView(view)
                .setPositiveButton(R.string.ok, (d, w) -> {
                    String u = user.getText().toString().trim();
                    String k = key.getText().toString().trim();
                    if (u.isEmpty() || k.isEmpty()) {
                        toast(R.string.recharge_empty);
                        return;
                    }
                    new Thread(() -> {
                        AuthResult result = auth.recharge(u, k);
                        runOnUiThread(() -> toast(result.success
                                ? R.string.recharge_success
                                : result.message));
                    }).start();
                })
                .setNegativeButton(R.string.cancel, null)
                .show();
    }

    private void showServerLineDialog() {
        String[] lines = getResources().getStringArray(R.array.server_lines);
        int selected = session.getServerLine();
        new AlertDialog.Builder(this)
                .setTitle(R.string.server_line)
                .setSingleChoiceItems(lines, selected, (dialog, which) -> {
                    if (auth.pingServerLine(which)) {
                        session.setServerLine(which);
                        toast(R.string.server_switch_ok);
                    } else {
                        toast(R.string.server_switch_fail);
                    }
                    dialog.dismiss();
                })
                .show();
    }

    private void toast(int res) {
        Toast.makeText(this, res, Toast.LENGTH_SHORT).show();
    }

    private void toast(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }
}
