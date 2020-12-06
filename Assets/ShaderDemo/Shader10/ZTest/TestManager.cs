using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
public class TestManager : MonoBehaviour
{
    [MenuItem("Test/Identifier")]
    static void GetApplicationIdentifier()
    {
        string applicationIdentifier = PlayerSettings.GetApplicationIdentifier(BuildTargetGroup.Android);
        string bundleVersion = PlayerSettings.bundleVersion;
        Debug.Log(applicationIdentifier + "--" + bundleVersion);
    }

    [MenuItem("Test/EditorBuildSettigns")]
    static void TestEditorBuildSettings()
    {

        string[] arraies = EditorBuildSettings.GetConfigObjectNames();
        foreach (var item in arraies)
        {
            Debug.Log(item);
        }
    }
}
