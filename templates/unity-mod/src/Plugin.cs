using BepInEx;
using BepInEx.Logging;
using HarmonyLib;

using UnityEngine;

namespace UnityMod;

[BepInPlugin(MyPluginInfo.PLUGIN_GUID, MyPluginInfo.PLUGIN_NAME, MyPluginInfo.PLUGIN_VERSION)]
public class UnityMod : BaseUnityPlugin
{
  internal static new ManualLogSource Logger;

  private void Awake()
  {
    Logger = base.Logger;
    Logger.LogInfo($"Plugin {MyPluginInfo.PLUGIN_GUID} is loaded!");

    Harmony.CreateAndPatchAll(typeof(UnityMod), null);

    Logger.LogInfo("Patching complete");
  }

  // [HarmonyPostfix]
  // [HarmonyPatch(typeof(HeroController), "Start")]
  // private static void Start(HeroController __instance)
  // {
  // }
}
