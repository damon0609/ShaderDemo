using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReplacementShader : MonoBehaviour {
    Camera mCamera;
    [SerializeField] Shader replacementShader;
    void Start () {
        mCamera = gameObject.GetComponent<Camera> ();
    }

    private void OnPreRender () {
        mCamera.SetReplacementShader (replacementShader, "");
    }

    private void OnDestroy () {
        if (mCamera != null) {
            mCamera.ResetReplacementShader ();
        }
    }
    void Update () {

    }
}