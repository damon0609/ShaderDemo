using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenPostEffect01 : MonoBehaviour {
    Camera _renderCamera;
    Camera _originCamera;
    [SerializeField] Material material;
    [SerializeField] Shader shader;
    private RenderTexture _rt;

    private int propertyID;
    void Start () {
        _originCamera = gameObject.GetComponent<Camera> ();
        GameObject go = new GameObject ("renderCamera");
        _renderCamera = go.AddComponent<Camera> ();
        _renderCamera.CopyFrom (_originCamera);
        _renderCamera.enabled = false;
        propertyID = Shader.PropertyToID ("_CustomDepthNormalsTexture");
        if (_rt != null) {
            RenderTexture.ReleaseTemporary (_rt);
            _rt = null;
        } else {
            _rt = new RenderTexture (_renderCamera.pixelWidth, _renderCamera.pixelHeight, 24);
        }
    }
    private void OnPreRender () {
        _renderCamera.backgroundColor = new Color (0.5f, 0.5f, 1);
        _renderCamera.clearFlags = CameraClearFlags.Color;
        _renderCamera.targetTexture = _rt;
        _renderCamera.RenderWithShader (shader, "RenderType");
        Shader.SetGlobalTexture (propertyID, _rt);
    }
    private void OnRenderImage (RenderTexture src, RenderTexture dest) {
        Graphics.Blit (src, dest, material);
    }
    private void OnDestroy () {

    }

}