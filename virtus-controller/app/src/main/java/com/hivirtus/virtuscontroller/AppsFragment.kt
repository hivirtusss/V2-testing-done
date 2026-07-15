package com.hivirtus.virtuscontroller

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.hivirtus.virtuscontroller.databinding.FragmentAppsBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class AppsFragment : Fragment() {
    private var _binding: FragmentAppsBinding? = null
    private val binding get() = _binding!!
    private var allApps: List<AppInfo> = emptyList()
    private lateinit var adapter: AppAdapter

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentAppsBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        adapter = AppAdapter(emptyList()) { app ->
            SelectionHolder.selectedPackage = app.packageName
            SelectionHolder.selectedLabel = app.label
            (activity as? MainActivity)?.onAppSelected(app)
        }
        binding.appList.layoutManager = LinearLayoutManager(requireContext())
        binding.appList.adapter = adapter
        binding.searchApps.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                filter(s?.toString().orEmpty())
            }
            override fun afterTextChanged(s: Editable?) {}
        })
        loadApps()
    }

    private fun loadApps() {
        viewLifecycleOwner.lifecycleScope.launch {
            val apps = withContext(Dispatchers.IO) {
                AppRepository.load(requireContext().packageManager)
            }
            if (_binding == null) return@launch
            allApps = apps
            filter(binding.searchApps.text?.toString().orEmpty())
        }
    }

    private fun filter(q: String) {
        val query = q.trim().lowercase()
        val list = if (query.isEmpty()) allApps else allApps.filter {
            it.label.lowercase().contains(query) || it.packageName.lowercase().contains(query)
        }
        adapter.submit(list)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    private class AppAdapter(
        private var items: List<AppInfo>,
        private val onClick: (AppInfo) -> Unit
    ) : RecyclerView.Adapter<AppAdapter.VH>() {
        class VH(v: View) : RecyclerView.ViewHolder(v) {
            val icon: ImageView = v.findViewById(R.id.appIcon)
            val name: TextView = v.findViewById(R.id.appName)
            val pkg: TextView = v.findViewById(R.id.appPackage)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
            val v = LayoutInflater.from(parent.context).inflate(R.layout.item_app, parent, false)
            return VH(v)
        }

        override fun onBindViewHolder(holder: VH, position: Int) {
            val item = items[position]
            holder.name.text = item.label
            holder.pkg.text = item.packageName
            holder.icon.setImageDrawable(item.icon ?: holder.itemView.context.getDrawable(android.R.drawable.sym_def_app_icon))
            holder.itemView.setBackgroundColor(
                if (item.packageName == SelectionHolder.selectedPackage) 0x2Ec62828 else 0xFF161018.toInt()
            )
            holder.itemView.setOnClickListener { onClick(item) }
        }

        override fun getItemCount() = items.size

        fun submit(list: List<AppInfo>) {
            items = list
            notifyDataSetChanged()
        }
    }
}
