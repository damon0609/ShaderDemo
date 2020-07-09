using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeOutAndIn : MonoBehaviour
{
    public Material material;
    void Start()
    {

    }

    private void Update()
    {
        if (material != null)
        {
            material.SetFloat("_FadeTime", Mathf.Clamp(Mathf.Sin(Time.time), 0, 1));
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_FadeTime", Mathf.Clamp(Mathf.Sin(Time.time * (float)(3.14 * 2)), 0, 1));
            Graphics.Blit(src, dest, material);

        }
    }

}