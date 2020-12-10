using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMatrix2 : MonoBehaviour
{
    private Camera mCamera;
    [SerializeField] Material material;
    private Vector3 mCameraPos;
    private int id;
    void Start()
    {
        id = Shader.PropertyToID("_ScreenImage");
        mCamera = gameObject.GetComponent<Camera>();
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetTexture(id, src);
            Graphics.Blit(src, dest, material);

        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}