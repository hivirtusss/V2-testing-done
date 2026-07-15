package com.hivirtus.virtuscontroller

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.hivirtus.virtuscontroller.databinding.FragmentModuleBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class ModuleFragment : Fragment() {
    private var _binding: FragmentModuleBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentModuleBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        binding.modulePath.text = ModulePaths.MODULE_DIR
        binding.btnRefreshModule.setOnClickListener { refresh() }
        binding.btnOpenWebUi.setOnClickListener {
            runCatching {
                startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(ModulePaths.WEBUI_URI)))
            }
        }
        refresh()
    }

    fun refresh() {
        CoroutineScope(Dispatchers.Main).launch {
            val summary = withContext(Dispatchers.IO) { ModuleStatus.summary() }
            binding.moduleStatus.text = summary
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
